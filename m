Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533033AA4F9;
	Tue, 21 Jul 2026 22:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673873; cv=none; b=rMeUxV669cOrMUp6q7+9yZyXG/fZhIz81TXPYQiPO+oIDTbk9iTpqNSCDtHfjy34H7OBmHnODmKW6KQYCH85q8HROLc0BJ5tNMafwgsEkvBCpt6+UmtbtqlufV0bgihtZY3CpPGqNy+FQdNPseqNrMo9Y8JAnNc9LqOGl9uUqHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673873; c=relaxed/simple;
	bh=Z6arQiFx/vMy7JJgh2B1P8j79XWz+bPFEIhPH9Jh66A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrVo6HBwaSHPI0+War2XKFGWDPthUsbVli6KdUYouVCCCZzemuHQErtr1pzvPo7r1ep2fuVlg6NG9NI1Kq1PjYljFIrsWGRSe3pePZorDYN07VHsS5eVldZZURgO/4ZfPAM3HgoDmEulIZFJFUYkoY0VdV/2vZQXQnSqI07je1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAPTv9WI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAPTv9WI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3801F000E9;
	Tue, 21 Jul 2026 22:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673872;
	bh=luK6Gy2U+cRFa8oRt7kjFEQeGYKaI+EbFJf9LXaaRRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAPTv9WIs5LGvc4qD5LpXIbwUaTPnWTPW9TTeNlUnVbdElj24maj+/aNIgu/wHN8y
	 tqlbvMcewB6DALynX9pmQcf3+n/UrylmGh391Ie7sFAUPv8XKt03OeBPAZX06cSOpc
	 c5Wks+4O8BC9EepYWfEAFtjnqS2qI0qo8T2952ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/699] apparmor: fix potential UAF in aa_replace_profiles
Date: Tue, 21 Jul 2026 17:21:27 +0200
Message-ID: <20260721152403.090180673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 security/apparmor/policy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -922,6 +922,7 @@ ssize_t aa_replace_profiles(struct aa_ns
 	struct aa_loaddata *rawdata_ent;
 	const char *op;
 	ssize_t count, error;
+	ssize_t udata_sz;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1106,13 +1107,15 @@ ssize_t aa_replace_profiles(struct aa_ns
 	mutex_unlock(&ns->lock);
 
 out:
+	udata_sz = udata->size;
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


