Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9600D175BF;
	Mon, 12 May 2025 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073024; cv=none; b=QLXQiY5olxF5wFynkEuRO8N9SYLlys0N/CwSSANxxGQNkPWe0fWRUE+qOXdvf6mEgxz6TMX5ACyVTs2RI7axfRKOAVDCFqwIUff0pW8ZU7rQf1FF0dH/R5v1pwaSqMZmGrOYr15D6y/CbTzYu3JT9jDDtiqxvcWzJH1WvXQdDsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073024; c=relaxed/simple;
	bh=AkfYpMtSJVy5w4IILHrKQrO7Naow2kRzXTm34yofGrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUHOej5ZqfSgzoSOOzZRcUfhx0HlbZPFYdwtTa9Y6QF4p1KPIT7lpLyLU8S44NDj/GT4vsxHzpZSABzX/65gPAqknrsy4PHXioawVYXq9bAtjk6ldAhFky0FaRxKyEq1EJS6MoSRw8gp9uinmbR4erUugzaYL9MbT15tDtjX8e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcU4FCG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcU4FCG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2FCC4CEE7;
	Mon, 12 May 2025 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073024;
	bh=AkfYpMtSJVy5w4IILHrKQrO7Naow2kRzXTm34yofGrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcU4FCG3iZWlFc/xHFqNrgC3hGCs0w8Ckt/O0Sk13W8xFKz8oqlDNuk8e32O3EvCP
	 ssOBq8tQTed853SysDmuLdyobZ0vW43e/1ANzJ+e52+3sDK2JJXhy9RwliqwqfWHKT
	 0wkWxWiTLT8L7oPyeGIsd39gGqXk8OdQ0koKbYcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 101/184] drm/amdgpu/hdp7: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:45:02 +0200
Message-ID: <20250512172045.936186275@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 5a11a2767731139bf87e667331aa2209e33a1d19 upstream.

Reading back the remapped HDP flush register seems to cause
problems on some platforms. All we need is a read, so read back
the memcfg register.

Fixes: 689275140cb8 ("drm/amdgpu/hdp7.0: do a posting read when flushing HDP")
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-April/123150.html
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4119
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3908
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dbc064adfcf9095e7d895bea87b2f75c1ab23236)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c
@@ -33,7 +33,12 @@ static void hdp_v7_0_flush_hdp(struct am
 {
 	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
-		RREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+		/* We just need to read back a register to post the write.
+		 * Reading back the remapped register causes problems on
+		 * some platforms so just read back the memory size register.
+		 */
+		if (adev->nbio.funcs->get_memsize)
+			adev->nbio.funcs->get_memsize(adev);
 	} else {
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 	}


