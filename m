Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914CC246781;
	Fri, 15 May 2026 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862836; cv=none; b=ZJrmSDlZV6LJP1bfSHN6KkpTR1GJFZ/Mg23gqsPOHkzbzbWG6U7i5YUywDj/tXPo8tag17MtZkmNp8IdR50Na2DdTEbYco8FPnOWZ31H/vKfOs5J3EvujaCT/UPTw/Fx1XiC8nHzPLQu+bYjL3vUWulUlYjY8akTih4E0uGNxxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862836; c=relaxed/simple;
	bh=yEFO6+EKbn0TsbBK33ZEkNT0jxQaHF0kHWQyayN4HdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3qLZh27NkLmh/3SMjucDXksIBd4g17kKinDSmCc5xBYVX0QnavhKOAQsLXS44o8NoqU6vNTtkJ7Rw+pPhx/jfTiqwugXkTzaCmePnnWfhj5XmRVIdu8cJA0rYj+693z8CsyiRMz5x7MMfYUcrHK+QNqIufHFIrS2X0b3qa23pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/XxvI6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/XxvI6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB171C2BCB0;
	Fri, 15 May 2026 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862836;
	bh=yEFO6+EKbn0TsbBK33ZEkNT0jxQaHF0kHWQyayN4HdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/XxvI6KuOrCpPJ49NvoZzrgFjro0N5Lyz1z8vNzNPfNGkQM2Rjaqm8LqLK9Kj2pf
	 jZqbfFSN44tj4oRQVvvnZRfBQ2K50oA5AwzkaK8UvsHP4BlFGnjA2pqTlPf10W7OUo
	 6NxV1qChI1ZIbSC9PWvmRbbDForGtmc7D2AF11P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SDL <sdl@nppct.ru>,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 201/201] drm/amdgpu/vcn4: Avoid overflow on msg bound check
Date: Fri, 15 May 2026 17:50:19 +0200
Message-ID: <20260515154702.933552718@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit 65bce27ea6192320448c30267ffc17ffa094e713 upstream.

As pointed out by SDL, the previous condition may be vulnerable to
overflow.

Fixes: 0a78f2bac142 ("drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg")
Cc: SDL <sdl@nppct.ru>
Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3c5367d950140d4ec7af830b2268a5a6fdaa3885)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1889,6 +1889,7 @@ static int vcn_v4_0_dec_msg(struct amdgp
 
 	for (i = 0, msg = &msg[6]; i < num_buffers; ++i, msg += 4) {
 		uint32_t offset, size, *create;
+		uint64_t buf_end;
 
 		if (msg[0] != RDECODE_MESSAGE_CREATE)
 			continue;
@@ -1896,7 +1897,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (size < 4 || offset + size > end - addr) {
+		if (size < 4 || check_add_overflow(offset, size, &buf_end) ||
+		    buf_end > end - addr) {
 			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;


