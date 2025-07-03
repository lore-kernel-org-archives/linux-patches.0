Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492252EE281;
	Thu,  3 Jul 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555133; cv=none; b=ktWppuzc9fs+sGVC9z6sLHfG3nZB7ONaDbhE285UsZ/U0nzItipOhNcKHQ+swUg0K9qoaLV/elni4vuEhEoLEKDpNssJpZm9b8KX8ZRRgu7UtYltZLev6C4qGT4YoDENgRtdndbQ+0FtGPTXT7pKRcmNMya5IySMiC7KVaDDskY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555133; c=relaxed/simple;
	bh=9LFNUqzj/hFQhM+nrJJEBA9irFkQ8gbqM5oxf4NmsBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgmFzDb6MJZHtac8tXPU27muMkgz/OA1UuhoTnkXAg4R4ZEPJ5Sn2moa64+McsCnlMMRKopajHJTZ52PkVcq+sADLeZ55O+gXA11OMt5WUeEG044aH9E0vn3/KgR/ULeco2S1+w6qGQMr8kT503xShbvRKIOhVmFQI0IQVzsUII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxRihC7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxRihC7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FA7C4CEE3;
	Thu,  3 Jul 2025 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555133;
	bh=9LFNUqzj/hFQhM+nrJJEBA9irFkQ8gbqM5oxf4NmsBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxRihC7Fg43bogjd4nHEx8VciNEH0ksgi5FW6WPYhUjrVpzeHu7OUVq3nmCw+xVmL
	 /wTS4lruP8Rs3rO4wQCYX3orkYJeAtpSko4AMbRfS1V8EjA7ZNK3aouo46C/WmCHX3
	 ih4XhZZkglzy+w2B9Rd/6Q05NDmf7eU7I6NNmxNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guido Trentalancia <guido@trentalancia.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.15 185/263] selinux: change security_compute_sid to return the ssid or tsid on match
Date: Thu,  3 Jul 2025 16:41:45 +0200
Message-ID: <20250703144011.758733118@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit fde46f60f6c5138ee422087addbc5bf5b4968bf1 upstream.

If the end result of a security_compute_sid() computation matches the
ssid or tsid, return that SID rather than looking it up again. This
avoids the problem of multiple initial SIDs that map to the same
context.

Cc: stable@vger.kernel.org
Reported-by: Guido Trentalancia <guido@trentalancia.com>
Fixes: ae254858ce07 ("selinux: introduce an initial SID for early boot processes")
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Guido Trentalancia <guido@trentalancia.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1909,11 +1909,17 @@ retry:
 			goto out_unlock;
 	}
 	/* Obtain the sid for the context. */
-	rc = sidtab_context_to_sid(sidtab, &newcontext, out_sid);
-	if (rc == -ESTALE) {
-		rcu_read_unlock();
-		context_destroy(&newcontext);
-		goto retry;
+	if (context_equal(scontext, &newcontext))
+		*out_sid = ssid;
+	else if (context_equal(tcontext, &newcontext))
+		*out_sid = tsid;
+	else {
+		rc = sidtab_context_to_sid(sidtab, &newcontext, out_sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			context_destroy(&newcontext);
+			goto retry;
+		}
 	}
 out_unlock:
 	rcu_read_unlock();


