Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D798546EC8E;
	Tue, 21 Jul 2026 19:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662705; cv=none; b=gjZ1L6bxeB/HGR9G4ysrmWSjmGFnmAG87inzmi4UrzUuHj4CT1XNvuI1q/lwLwEIlf4jcoGRXmDTYry+Uos3AYMQV8DUQL3+7s3LNR5jGMD5NEdEnZRRxZFotRID5kWfjpRs5iE5jeb1Cnr49EVi3oHznV4RvN/fCHKQ3xb789g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662705; c=relaxed/simple;
	bh=o1rG7SrCeRKl8WKvlBHOoneqo4qGvEVeBkDwrXbRtCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATLTpMombFnId/hoowyJM7AoCuJaNY2qvYjKCkMT5U3Tha9aZJyjw/P7tqNHoyIRjc1naY9YfnS9a8SYoG8W5f1aDrH8lNbfkzgAwzts8CIiKHTYki4issdDWNPWodJm2PqSXubK534E1NaI+e7FxQSrCyugAWsu8i1tHSNarxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMkRSWaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMkRSWaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869A01F00A3D;
	Tue, 21 Jul 2026 19:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662695;
	bh=E8QVBN/meEOVYoAkPBT1R1vFwI8cgCAsnP2Ruj5e7BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMkRSWaAqEM/SgGLNhNFd7RKKi/tfFOxzf5towZ01MQX65inRsFw4nZMQ1bxlKuyI
	 ws0ADkR3tEjxGd6KXuokMDgZ0vEZyk7jEo/aV0Sjnsp60xG7o+9I1TNy9odx3Bj5Xj
	 EdVRBWB8YbMEiVK+q6rdoNpvqecg2Prkwa4Aj5A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0541/1276] apparmor: fix potential UAF in aa_replace_profiles
Date: Tue, 21 Jul 2026 17:16:24 +0200
Message-ID: <20260721152458.228501307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9140b613c0cf22..7fa1d2a08913af 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1327,13 +1327,15 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



