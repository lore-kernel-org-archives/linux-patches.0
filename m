Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D8D303A3D;
	Wed,  3 Dec 2025 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776370; cv=none; b=k5oZAuMz4YpP/O6Go9DvK18q4vmYZEIDM010OZx1+LBfpfYABxyErbD8ZAaU7PTgqnapb2jKcwtE+AwdhU5wUk4jIARy7ECHZI0gy3GwFK9ZnkXovF9DYI9w6GX2UN3IAzfnLA2/yOycKV3D2Eey/dkSxqYk/ewCTdpJ2Cnk8YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776370; c=relaxed/simple;
	bh=oW8D+t620lCk4YNQmixVBHFnwqz08Y+X4JwY3Jldpkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUiM9k5P6B5X+DtPrRFBD88qVAgZheuB6P8mmBunylPK0MLPWOk2CIi9kMxIiFOV3Y4G9BB0p7ClBJZ/SQdRYYeAXkreaBDgbRzh/AVZhoZObw22es6d/M+KPb+sRbm0yAd4+vrOj2Mnv75d4oSCSnfUP0bnZI4fHlF1yIfDkFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMUm/7HM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMUm/7HM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB0EC4CEF5;
	Wed,  3 Dec 2025 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776369;
	bh=oW8D+t620lCk4YNQmixVBHFnwqz08Y+X4JwY3Jldpkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMUm/7HMDTOwMRFt4TaPfHB72bZGJ9gnOvJC1b4F5s1msGG63RCxlD4rVXOIVPcdh
	 ttdwuHWtX7cuUtqYikwJWbiBEel5gQ/ifeGB0Skw0VUXBAjA7h8vs2AL9Djj3k2Olb
	 G53CGCTe8FOflTMli9ezSCX31bH6FXCzJhOYGglM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/300] NFSv4.1: fix mount hang after CREATE_SESSION failure
Date: Wed,  3 Dec 2025 16:25:39 +0100
Message-ID: <20251203152405.615358811@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit bf75ad096820fee5da40e671ebb32de725a1c417 ]

When client initialization goes through server trunking discovery, it
schedules the state manager and then sleeps waiting for nfs_client
initialization completion.

The state manager can fail during state recovery, and specifically in
lease establishment as nfs41_init_clientid() will bail out in case of
errors returned from nfs4_proc_create_session(), without ever marking
the client ready. The session creation can fail for a variety of reasons
e.g. during backchannel parameter negotiation, with status -EINVAL.

The error status will propagate all the way to the nfs4_state_manager
but the client status will not be marked, and thus the mount process
will remain blocked waiting.

Fix it by adding -EINVAL error handling to nfs4_state_manager().

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index e3cabced1aead..171bc21eb945b 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2724,6 +2724,9 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	case -ENETUNREACH:
 		nfs_mark_client_ready(clp, -EIO);
 		break;
+	case -EINVAL:
+		nfs_mark_client_ready(clp, status);
+		break;
 	default:
 		ssleep(1);
 		break;
-- 
2.51.0



