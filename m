Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED9A43B6D1;
	Thu, 30 Jul 2026 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422404; cv=none; b=DutH07iqL7pgjk2eAnQrhIe0xnwdd8Vg8dts/1MEK+v+0XQJDknymxKty+6I/V09mL5aQkjgwHiNc6HWPANmlJPSdtAQou0aObe4h2OrwUf9BuiPiFvNF0wxtwx7hLFqmbH6FvaZ6lAFeDf2MPTIn6leiEXK6nTYpcaM2Y9xWlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422404; c=relaxed/simple;
	bh=C8FjrQdG46jedidf4SH9IPVOyYYOzYrLX/i8gK0ulng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LoAqfO0qk78yDoL4fHClZZIFsY1OYrYMjz3s5p+nLwoNq9TpWJF8fBig8Ugq33+8EJuUzoWZ2a4HX5u2zbd8jNhFO9cYwlkChKng8/L/ft7F6Y1j+7v7Xk6zv7CA60OatNSWCsB7uw8rh8X+54dI9BJHKQLbOCRO5SiVt02uBs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpum04Tf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpum04Tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14471F000E9;
	Thu, 30 Jul 2026 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422403;
	bh=nqHnyx9kePjldhTQqo5t22WrKCYHjvzht9uyz1NpHjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpum04TfUSlJbOz+b9UZ8NsHkUcACEJb5rFehwNcdbK8k/SV/XFMHtQrBypYqk5Y3
	 WplAnW7n51EZXVCf7Xv+z9AVwIIFbP4WL6yOlpvBWSzElyeo9fsplhL2TqfWhZ8qii
	 ECD+Tz8ocynaB7W7kd+x9GdtSgmQ4yDTZ2zH7GRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 427/744] drm/amdgpu: add the doorbell index input for suspending userq
Date: Thu, 30 Jul 2026 16:11:40 +0200
Message-ID: <20260730141453.373742360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

commit b181bf68d11f034efe27ae1377a0f659605f040f upstream.

It requires inputing the doorbell offset for MES firmware preempts the
userq, and adding the doorbell offset also keep aliging with the
union MESAPI__SUSPEND in MES firmware.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bc434335ab3c096a33a9e88c7951b4ac574db458)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
@@ -288,12 +288,14 @@ struct mes_suspend_gang_input {
 	uint64_t	gang_context_addr;
 	uint64_t	suspend_fence_addr;
 	uint32_t	suspend_fence_value;
+	uint32_t	doorbell_offset;
 };
 
 struct mes_resume_gang_input {
 	uint32_t	xcc_id;
 	bool		resume_all_gangs;
 	uint64_t	gang_context_addr;
+	uint32_t	doorbell_offset;
 };
 
 struct mes_reset_queue_input {


