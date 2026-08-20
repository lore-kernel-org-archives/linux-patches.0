Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DE337DEBF;
	Thu, 20 Aug 2026 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238081; cv=none; b=YIAPc+m4d4SggmfVmDlSZm7neLplP7eso+tuCwZYW1/v/V6Aqx+IEgqKIOYnbyH/xSRx0gHIQ0tyVngUzQg+/zRwU7DC4o+8HOKHAwDYsElaF0OATmue6qP2N7rDcUr+8m6MfLZcKbxZkt0gK3TtkGBNI2+GRG6AylfBlGnetQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238081; c=relaxed/simple;
	bh=1CHguuhyKrNAqdiogpjSwCJA8BJfEovl5lpY7vMUQ70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLGWWERYu4IGa9UeGloJJ9439Nr3eps28dxW+3+tTggWrcGipkMzxIKm/paGzQRqm4ZMRFl1Ip5vaZd1yb0o0VEdUIj0gtIxsSB3e4vXhnKbw8RMwVIrLLoDKI6PRIVRdYtX+y65LB95oVUd7A6v3jZ0NF/FQOWs2d1fqeNs7B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYY0h7Ic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYY0h7Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED511F00A3E;
	Thu, 20 Aug 2026 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238079;
	bh=Egvlx5uVLaJAvj4y70F/JmO9eBVX2QzZyiCWbXHoh1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYY0h7Icq671PuyRv6p3IdvBNrbLaTXXpjUkaDXx619larTcqbPrXnd9MVqB/CuuA
	 zl4ePPmOgr+UCjKc0Ec7oqE+pC0jo+3C84P4wp/fio9lzpawtSw6Kz9IHLBRQIdB0n
	 uPfhovzuYCwJfnAtkargDSpJdJrzsfTq65fm2rl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 7.1 026/228] drm/panthor: skip zero-sized firmware sections
Date: Thu, 20 Aug 2026 16:52:48 +0200
Message-ID: <20260820145245.252973883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 2b8f13d3c7e26c46c20d9e367904cf01729c88e6 upstream.

panthor_fw_load_section_entry() skips BO creation when the firmware section
VA range is empty. If such a section is added to the firmware section list,
section->mem is left as NULL.

Later reload and unplug paths iterate over all firmware sections and
dereference section->mem, which can lead to a NULL pointer dereference.

Zero-sized firmware sections are valid, so accept them as no-op entries but
skip adding them to the section list.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260724172621.63046-1-osama.abdelkader@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -600,6 +600,9 @@ static int panthor_fw_load_section_entry
 		return -EINVAL;
 	}
 
+	if (!section_size)
+		return 0;
+
 	name_len = iter->size - iter->offset;
 
 	section = drmm_kzalloc(&ptdev->base, sizeof(*section), GFP_KERNEL);


