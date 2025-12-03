Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B1303A28;
	Wed,  3 Dec 2025 16:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777988; cv=none; b=mTzSGqrg60gNtZPIk47Z2ER4iya0BRAmDslfbprQm74207YeatOE1dgwzixeFo7Na2PfOp2x/UMBx9oIdnGzj6iVOx9b2GJnIqQvaeDgRhggwUUP9PXyfmtiJviXLqPCO3vqIe7WxJgivbb2h6Q+Ra/a/Vniuxpzzqcc5Q5qmT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777988; c=relaxed/simple;
	bh=Ny0iphFx9NwaBpLmJvApsQhb7nLPDL8D8X/8ucsuj40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuX/zoTDN4+DOvXrt83nzX6HGc/fxOSqx2L//lEHfaDl5EDfiFNX+P5fIm7lX0BtDiRHSvXZNfOP4cBhyDbj95an/JCs94/hbNYz1VPV1eaPG959MlheCHdEajy43jBWZ2N1iKgbElQzEWPznbcKFX+E5Ym1AxLc1ax9skie1RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxEnMfhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxEnMfhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89370C4CEF5;
	Wed,  3 Dec 2025 16:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777988;
	bh=Ny0iphFx9NwaBpLmJvApsQhb7nLPDL8D8X/8ucsuj40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxEnMfhCPk317rIm4Xytn72ib6KTcWR58hIN/eT6OgPW0GhOC5loT4wI2zKfvpl85
	 QS/MPPIxPM8Do4Wlgp5AYL2wQeTSno+aDBGMqrZVksQ2sfutTNhe0Bx/OZcAP3YI1y
	 gmM08oolZc0ubSO8CS5V/QqdYbWD/+zHe+RE/ug0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/392] NFSv4.1: fix mount hang after CREATE_SESSION failure
Date: Wed,  3 Dec 2025 16:25:25 +0100
Message-ID: <20251203152420.517083273@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b1dec7a9bd723..d070378c47387 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2731,6 +2731,9 @@ static void nfs4_state_manager(struct nfs_client *clp)
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



