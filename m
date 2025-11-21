Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051EB34403B;
	Fri, 21 Nov 2025 13:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732870; cv=none; b=DQWnGbTvg+OWbJqpod74IotOZvopKQjXolx5J3J1W1TCfAssE9LpBzHZBZfG07Erl4np7z6MwH53OHrqKxrFWvK1Sw6+pkv4HEwRGHXCo1dhTIh6eHuMgf4EK01voaHgLKOqUuHVLaamOvBfl8jx4GBY/sGG0T6Ahtvrv4a83HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732870; c=relaxed/simple;
	bh=LPljobZcc0oo3Hw60/zRknBEqX3Xo8ebvxMEgJd52Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgYdT4cGEGjZC4MTO1sN2i76rjvcyISyUjnKvnDhx/bs6fZQbFYLDctKOzTRtNUlWExWQfpkjbuqzXJnh4dROUaia68jEZUJAlULmjsc21gPuvMZTiTRRK71G3ybLQII9UU7ZyFT3M3A6v2laB5qopEXKJk3QusA4DLkSwHzVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajP3YYsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajP3YYsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305ACC4CEF1;
	Fri, 21 Nov 2025 13:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732868;
	bh=LPljobZcc0oo3Hw60/zRknBEqX3Xo8ebvxMEgJd52Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajP3YYsM9sdD1Q7JYERn5qU4PCe2A7Xs0x8SW+dHPmkeNHqZpo947TvMzrSIch7oQ
	 MUHM6dntk6vDkrkfqGP+kCXdh6MC4DC31v2iGndZeEXZUi/ZBv11w8s74OgkyPznYW
	 AFQ5pKrFvuUMbobm5av9W5/v15BxFDi7aKKRhG9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/529] NFSv4.1: fix mount hang after CREATE_SESSION failure
Date: Fri, 21 Nov 2025 14:09:29 +0100
Message-ID: <20251121130240.628480345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9fc71dc090c25..78d52c2006dcc 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2746,6 +2746,9 @@ static void nfs4_state_manager(struct nfs_client *clp)
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



