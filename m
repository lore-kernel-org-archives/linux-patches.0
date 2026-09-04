Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783FD410D36;
	Fri,  4 Sep 2026 06:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501824; cv=none; b=BcGCknARwP5a/dT7B8q52d8TFTCIBCUqSwmSGiaYMLM+10zLz6kTZJmWenyR+dA/tETCAhLSC4HC7H3G5B8rugdvYYZOuY39xy09zxAT2/GuHk5laTAj05Efks+vSSxaZSE6gHSzWvNBOM2O2yXpd0yMh0hPRgxHADopt9eaU4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501824; c=relaxed/simple;
	bh=s8So7b+RohfWSbSvBo/YsoenvV6/ZbXxx65ESzLkmlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xgdc6shUdXO8GpcIHuEk0XXCROeLUCL7TSk5P0CRD7GUYYWRY4DTr9YWx1KQoSXVBwv0vx15m7pw+LN153JdWbP+uWJA1+62Zqpq02azzsRV6IeFVrJwtO6LduIgcwVYUBijOH+KoNUvwoiJr2JSYgwA21b/luP+5i9eeCLs9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lK3AKwpO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lK3AKwpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61A81F00A3D;
	Fri,  4 Sep 2026 06:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501823;
	bh=RVQ1TgPLz5SMrTyZfU1EskEoVqU6tO6JDv6zcLTZWss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK3AKwpOXB49CSbPXCGNHnIN22miUFmGAJiu19VZb4sbnfmmioBgev3OWtJA3uRTx
	 X5SnR3QGB6wXupmQQEBof2r1kkGJq/TpDyKHiryRpwWXJ3wqGrERdFqNfcRnz0y3/a
	 k0CS8SVVa7ydw3ClbJW+aiDuVKtHGE05a+HjIQSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 6.18 546/552] smack: fix cred UAF in smack_file_send_sigiotask()
Date: Fri,  4 Sep 2026 07:01:43 +0200
Message-ID: <20260904045802.980359515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit fedc88e38ce979a720cd2de042578cb5df3dc8de upstream.

When inspecting the credentials of another task, objective credentials
(->real_cred, accessed with __task_cred()) must always be used.

Accessing ->cred on a non-current task is forbidden unless that task is
being created or destroyed; a task is allowed to change its own ->cred
pointer with no synchronization, and changing ->cred should only affect the
current syscall.

smack_file_send_sigiotask() was accessing both sets of credentials: First
tsk->cred, then __task_cred(tsk).

Fix it, always access the objective credentials here.

I have tested that this bug can lead to a KASAN-reported UAF of struct cred
in smack_file_send_sigiotask(), and that this fix prevents the race.

Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/smack/smack_lsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1969,7 +1969,7 @@ static int smack_file_send_sigiotask(str
 {
 	struct smack_known **blob;
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(smack_cred(tsk->cred));
+	struct smack_known *tkp = smk_of_task_struct_obj(tsk);
 	const struct cred *tcred;
 	struct file *file;
 	int rc;


