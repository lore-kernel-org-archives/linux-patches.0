Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD02D194A5B;
	Thu,  5 Sep 2024 09:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530327; cv=none; b=VB3//EKXnPyPEoDI+NWdj43ygtrPW8fnN7eWAjjDCQ/tTomUU+QafkS5LR5NBfUvu3KSNN8xI/304LVekk1JnyAuoRIm+R41dm3GasCNYIVURKG9Z9JQVrM3AobBknx+5+AVCekqyFfTpkHFe2+KhJhHKBHl7nXxdR3sOl1K0wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530327; c=relaxed/simple;
	bh=rAWkPtbLrUU7orMKL4F7SU7yv9Zst+kfZhmwviJ4Q1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlYygl9U0P0MtxMAo/d7FX/O+fA6cNqL5SXbda0QsxHs2fTIocyJYTewccoZUI88CSLqi0E2F77EJDs7qCx5BepzA/RRcbTki8/zAO3isJH5zUVmjcViAmXbCXkDPgEAAWHvdkzAqrLSgIaBHoOvXpcGnpWmEtXecYdj73lSln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRPp6pWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRPp6pWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7796C4CEC4;
	Thu,  5 Sep 2024 09:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530327;
	bh=rAWkPtbLrUU7orMKL4F7SU7yv9Zst+kfZhmwviJ4Q1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRPp6pWkdJgauqxgUjvYNURlrsCIj+xKXHN5bJBHCXwr2bB3FgJ2akt5GaKHlFGTx
	 ORQOEs+CDp+GNE6WKtCjdLJV8ylEWr4y7+9tXqJS2rUristiOb8PuyeUwiAZ9nHQko
	 bK1C+IbKq69kfTXeqAZmR+w39Evu+02qrANyGFq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/132] drm/amd/display: Dont use fsleep for PSR exit waits on dmub replay
Date: Thu,  5 Sep 2024 11:41:50 +0200
Message-ID: <20240905093727.000065008@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit b5236da757adc75d7e52c69bdc233d29249a0d0c ]

[Why]
These functions can be called from high IRQ levels and the OS will hang
if it tries to use a usleep_highres or a msleep.

[How]
Replace the flseep with a udelay for dmub_replay_enable.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
index 28149e53c2a6..eeb5b8247c96 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
@@ -102,7 +102,8 @@ static void dmub_replay_enable(struct dmub_replay *dmub, bool enable, bool wait,
 					break;
 			}
 
-			fsleep(500);
+			/* must *not* be fsleep - this can be called from high irq levels */
+			udelay(500);
 		}
 
 		/* assert if max retry hit */
-- 
2.43.0



