Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44A335BA;
	Thu, 13 Feb 2025 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458358; cv=none; b=IfIgdMpNdC1vVZKOHqR89KU/JeWCCWCqS5KA2XF8cb1+mY1290gZlVbvxutm7BnBFQBHfJMqoWkYhQBBVa+ZWNBsXnWQBN9r38niDbFDZvhah6JZUKE5MdV45r/E40q1csVfRGeFqEGeEVSs0h0PgCKVCO9+2gGVVZXrbLe8ENE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458358; c=relaxed/simple;
	bh=oLdSAk3GOZkZ2w2zO97/fbiE5jaob9bXaT84V1JbBgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJId7y3wSXjWUiz+XuQmpMyRS+AEoZEUF/dJYGMuEbrioZBeC3+8xjHjed9pjbqpcknUspEdHPXwPzmMSoXAmMy2s//5YWUgMds/C53ubqfr5sKojn1uhdgo+3IRyTPzVc+jGyGM1EpMUTQffxzrT9YzG1WO0bVNdsWFHAb0N9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDrixBXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDrixBXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188B6C4CED1;
	Thu, 13 Feb 2025 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458358;
	bh=oLdSAk3GOZkZ2w2zO97/fbiE5jaob9bXaT84V1JbBgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDrixBXwQ4DWNQeYkR/hBukQBCQKW7MZKGhldCMZ0IEUvl/ZJUcej1Vjg5dINETaq
	 opizaBzMKrwiPNeSy+rK3+2qAx5mwvz9HAvVN0xgAIrsNgFpc/ujgKRJZ9cIV9v1c6
	 7LxnV4T6ypOtkT8mluRXUY1i9o8fWAXS9hrZ7Zvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 377/422] misc: fastrpc: Fix copy buffer page size
Date: Thu, 13 Feb 2025 15:28:46 +0100
Message-ID: <20250213142451.095570106@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


