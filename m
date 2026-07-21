Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A9B471255;
	Tue, 21 Jul 2026 18:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657381; cv=none; b=tKxWRaWH1i+yaxxiRrPcnFQuX8oHx+O8DHVu3t5ekV110leSoqfETajkIZ39J0HlDT0OEjF/aVILVv43qtzyoulcC3OO12dRZBqDifwjD0EWMNC89eoWtgqAoUpq6N0zDWyj9budLE72Y9xLvFs0qYnLE4Elf3+Zuv5mS0nJNo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657381; c=relaxed/simple;
	bh=j+XfWXjtNvknRWlWUZdSoq7QCae+N2AD7at6dNsCbgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8wpCmm607lmPT3ZchDIn7dcMU/Qiu0aT4+aCcBR14J/UJgFw0ysU8Luu8HAmXUcSz1P1hy0BUTsCnBDCI7gl/UXueUsW9lwjrN15N85cWCeijYjFb7ndEYfJ0jOBrqaNyehj2zDflR221xtcYakn2ZoAQ0DlTMN5JBHiTvwU8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqPFEOXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqPFEOXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57ED1F000E9;
	Tue, 21 Jul 2026 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657380;
	bh=BTcHmuKuYZ+tC5KRcCEvBrFVaUDzxlcztuuYzbMCHmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqPFEOXsDEoJ7jTuTr5q8Tov5PLnW3UrAy/1s7sVhYIZR4+SsBwyGqHNzz3bEwZln
	 IQz2w0b7lTIIPIa2Wd1ev5OsUzuVOEBIF35TggSrsNQ+fQwhzhChIHoMwn4Lkl5sIt
	 +Icz9/Q52LJW28vMGeHv+8YDjmbYg3W3Q04Ds2Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0741/1611] apparmor: fix potential UAF in aa_replace_profiles
Date: Tue, 21 Jul 2026 17:14:17 +0200
Message-ID: <20260721152532.043778399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 7b42f95813dc9ceb6bda35afcf914630909a19f9 ]

The function aa_replace_profiles was accessing udata->size after calling
aa_put_loaddata(udata), causing a potential UAF.

Fixed this by saving the size to a local variable before dropping the
reference.

Fixes: 5ac8c355ae001 ("apparmor: allow introspecting the loaded policy pre internal transform")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index c474a55fed22c8..6762124521aa03 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1358,13 +1358,15 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	mutex_unlock(&ns->lock);
 
 out:
+	ssize_t udata_sz = udata->size;
+
 	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 
 	if (error)
 		return error;
-	return udata->size;
+	return udata_sz;
 
 fail_lock:
 	mutex_unlock(&ns->lock);
-- 
2.53.0



