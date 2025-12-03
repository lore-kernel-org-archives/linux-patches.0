Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBBA3644A6;
	Wed,  3 Dec 2025 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779424; cv=none; b=rblM5A9398BTbYACDVER25+6bG3err2w60FT4DpNo1Hidz0EsAvVuK9EG02zFHdxsGEXVGlwXkPBO0BBRx9OyPf6i+41dNeOzrd/kcDV4rBO3f37DLXyaheL5ASK72BbzNSY1mg5YXMWmT23HCUd73J4I2QSuSSYUni8sq6BRBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779424; c=relaxed/simple;
	bh=s25iSyiWqe+08Zq7pu3lfwpf9epe4omVFDKkRIYbK0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmzEcCg8STOmDWFJHA3jBGMY4Z21l5SNiHfPpw5wJpILntJTH+/eF59vX8wp8eshDLj0WJ5nV9KNYASRitvS98ko7OrWPaEbHpYQcQwPmLfJ/m+kBkTlEcUBpYfKsDXmrqlzr3u2/XcYJeoLbneRwZVdABZ/MZBXajNZcZRuTbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PL1I8qYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PL1I8qYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178A4C4CEF5;
	Wed,  3 Dec 2025 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779424;
	bh=s25iSyiWqe+08Zq7pu3lfwpf9epe4omVFDKkRIYbK0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL1I8qYdYohcxgPvnfOQazFkKeEfDhOmZYZeSty7XFHUE7LkhjvlwYowEBFuPjTN4
	 TXoidMr6i3QwyFmus1XWbRyJYK9rl4rm9yY5K+KmtN5l5lyG+aLeh40+x+jI+jR1U1
	 e3SXMCQT4RYzFjDpkc8nlffzxodVcmK3ri/sTAeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/568] NFSv4.1: fix mount hang after CREATE_SESSION failure
Date: Wed,  3 Dec 2025 16:24:16 +0100
Message-ID: <20251203152450.023765828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80a7c5bd7a476..c30c6dbbf9254 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2742,6 +2742,9 @@ static void nfs4_state_manager(struct nfs_client *clp)
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



