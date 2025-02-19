Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87951EFFA9;
	Wed, 19 Feb 2025 09:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957237; cv=none; b=FdFK+3DBZeMT5r0fthzfxeUZxy6FwtPnIYaU1c+g8oKjI0uSjbvSe+e3SLgIOeOLYaIGgdtzubqkfQYaZmoUH41N16u0zCahPC8Y+LZpEhwck1/zJAuwcxNHPoiDrP8X6tBVhAr2oe5NOxY2QCUyHrYiGN1MIhg8avCxNCANYuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957237; c=relaxed/simple;
	bh=OxORLF/CzPuThe5U38EhYVbB2WVuRROlCEX1PlzK69Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdurGAkxfXj4mowcUwkEwWnWDP3vjd5Ry8w00FQ3W+Ursq7csQDCW4sLUj8FPX/hg/mQ6A7j9ehdbeomDadQEBdTFhhUPGEk6N9RdN5bZnflu1NDLq1t06f+FMX5GKbB2glcE3ibqUYnC6nQmQrP1WSAMgN0vYd67+FwdYttc/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4m3CFNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4m3CFNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0710BC4CED1;
	Wed, 19 Feb 2025 09:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957235;
	bh=OxORLF/CzPuThe5U38EhYVbB2WVuRROlCEX1PlzK69Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4m3CFNLY4h/BhkjUGmXCQT9b/ikm68oDSd47/fiwatGg1gEpK6gPTKtx1ftcXGCx
	 ffykbA1TUnviAVCVFaql5uhYXH8Uv2CnBzSeWQZ3xSB+pBqNDSKKp8UTI8LxNviZSx
	 5q4D2vFAprXYowRyL7ad72uXoILW+i4BTV/vl0sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 424/578] selftests: mptcp: connect: -f: no reconnect
Date: Wed, 19 Feb 2025 09:27:08 +0100
Message-ID: <20250219082709.696039082@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 5368a67307b3b2c347dc8965ac55b888be665934 upstream.

The '-f' parameter is there to force the kernel to emit MPTCP FASTCLOSE
by closing the connection with unread bytes in the receive queue.

The xdisconnect() helper was used to stop the connection, but it does
more than that: it will shut it down, then wait before reconnecting to
the same address. This causes the mptcp_join's "fastclose test" to fail
all the time.

This failure is due to a recent change, with commit 218cc166321f
("selftests: mptcp: avoid spurious errors on disconnect"), but that went
unnoticed because the test is currently ignored. The recent modification
only shown an existing issue: xdisconnect() doesn't need to be used
here, only the shutdown() part is needed.

Fixes: 6bf41020b72b ("selftests: mptcp: update and extend fastclose test-cases")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250204-net-mptcp-sft-conn-f-v1-1-6b470c72fffa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1216,7 +1216,7 @@ again:
 		return ret;
 
 	if (cfg_truncate > 0) {
-		xdisconnect(fd);
+		shutdown(fd, SHUT_WR);
 	} else if (--cfg_repeat > 0) {
 		xdisconnect(fd);
 


