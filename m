Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEB878F30;
	Thu, 13 Feb 2025 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460056; cv=none; b=VM/m08ZfR0Sc5x9pZKK4EUZf1KAbSQ4FWz/bqUHJpk6A1ZNvTBrKI7i3GNNx41NScHKGTp6gRzpa3RSpz5q+zieDtPGKboUkNuLWhnoxFoBYVhUGa8tu6HOU/lVwymU0Eu5U0R1LDbMIevFK/ItVmMtZRLVhq6czeXH0mGC9EEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460056; c=relaxed/simple;
	bh=RXTXUIwuSqEodO+3z5iCRDAjQhvtaUsicikddK2G1tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+XEIn97WufLdaFqrSsQhl7XMMvuzsS5ONl1mLgv4AGUAk7BuAZU5zH24tC977U9CgR4d9IHTmIc1P7zkU+X4RwiCtbJys5+bSOhGhBXGfbEfPLV6k+kJJAz79VDk6EcfhW4JNgWlau0S/Yet3XAztwLZ/hQ6Tmx2lbstH8+k+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogLeVTMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogLeVTMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFBFC4CED1;
	Thu, 13 Feb 2025 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460056;
	bh=RXTXUIwuSqEodO+3z5iCRDAjQhvtaUsicikddK2G1tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogLeVTMVio6aSOFI+44PITCyGtIxSqPN2Peh0XN2BkItmJCaTI3rJyz/jZ4TUT2Nm
	 4VnEvq/5sFQZM2wNpvkwSuQ+SvLHBU7ee6eejNuEcevBxvlFdoMVk7HqdiJJv7Ab61
	 l4QkX9X87cO7OwIaYRvOP6l+khkICkMatqxPba5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.13 414/443] misc: fastrpc: Fix copy buffer page size
Date: Thu, 13 Feb 2025 15:29:39 +0100
Message-ID: <20250213142456.585010772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit e966eae72762ecfdbdb82627e2cda48845b9dd66 upstream.

For non-registered buffer, fastrpc driver copies the buffer and
pass it to the remote subsystem. There is a problem with current
implementation of page size calculation which is not considering
the offset in the calculation. This might lead to passing of
improper and out-of-bounds page size which could result in
memory issue. Calculate page start and page end using the offset
adjusted address instead of absolute address.

Fixes: 02b45b47fbe8 ("misc: fastrpc: fix remote page size calculation")
Cc: stable@kernel.org
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250110134239.123603-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1019,8 +1019,8 @@ static int fastrpc_get_args(u32 kernel,
 					(pkt_size - rlen);
 			pages[i].addr = pages[i].addr &	PAGE_MASK;
 
-			pg_start = (args & PAGE_MASK) >> PAGE_SHIFT;
-			pg_end = ((args + len - 1) & PAGE_MASK) >> PAGE_SHIFT;
+			pg_start = (rpra[i].buf.pv & PAGE_MASK) >> PAGE_SHIFT;
+			pg_end = ((rpra[i].buf.pv + len - 1) & PAGE_MASK) >> PAGE_SHIFT;
 			pages[i].size = (pg_end - pg_start + 1) * PAGE_SIZE;
 			args = args + mlen;
 			rlen -= mlen;


