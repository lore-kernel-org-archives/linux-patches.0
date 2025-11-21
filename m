Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5A534DCCC;
	Fri, 21 Nov 2025 13:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732895; cv=none; b=WQTVs1Nu20zFpAtJ2ZkVLX83Ep5HZmt1MzvuOmDXbNgAi+mwtcSiLBVMipv9NPbyJ30fLtjPlV2pLFcbCwK6Yk0u1eYvh8XRDvwCYXR8OVbTr1x9o1W9cuYpGrj9mA25e7JjUsa8yvRshb69ptTKLRtbvdEM5jTkYxvgVfHA05A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732895; c=relaxed/simple;
	bh=Wu+gvNrF53q0GYAaZUf3s5tGzkJ7UsShfzGgCPTiQyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sklC3jZbKPvxhMWzWCVgxS5TVIw/yUmuoUQJgeESS3vnOIwG6wYTLMK30ABNc9ey+kynddv7VCu42GmpqwqpPr2I0+6UQ1F/9/qv++zHNw3CTtl1eUb6Za9Oi6V79G1naNI6JHhUuJt1arz6ak0XyFz6hA5rA+qas3oPqGuCmVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vjes7lla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vjes7lla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14D1C4CEF1;
	Fri, 21 Nov 2025 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732895;
	bh=Wu+gvNrF53q0GYAaZUf3s5tGzkJ7UsShfzGgCPTiQyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vjes7llaiCEafU+vCXdqCbbmL1gqjBO/s6SXzPJzocodI3xhAC64GWkH6fhYDjNOA
	 Z6BvUjhApB6vnkX4awrCvIYi5b/o9sUODoz446QwrcZ+d8AkPrGCsSgmqWcvlyyBbk
	 l4UNSJrYMUpww0LOTaM3pvVGlTb4ZYgD9tAqgYIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Forest Crossman <cyrozap@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/529] usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs
Date: Fri, 21 Nov 2025 14:09:06 +0100
Message-ID: <20251121130239.807131766@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Crossman <cyrozap@gmail.com>

[ Upstream commit 368ed48a5ef52e384f54d5809f0a0b79ac567479 ]

The usbmon binary interface currently truncates captures of large
transfers from higher-speed USB devices. Because a single event capture
is limited to one-fifth of the total buffer size, the current maximum
size of a captured URB is around 240 KiB. This is insufficient when
capturing traffic from modern devices that use transfers of several
hundred kilobytes or more, as truncated URBs can make it impossible for
user-space USB analysis tools like Wireshark to properly defragment and
reassemble higher-level protocol packets in the captured data.

The root cause of this issue is the 1200 KiB BUFF_MAX limit, which has
not been changed since the binary interface was introduced in 2006.

To resolve this issue, this patch increases BUFF_MAX to 64 MiB. The
original comment for BUFF_MAX based the limit's calculation on a
saturated 480 Mbit/s bus. Applying the same logic to a modern USB 3.2
Gen 2×2 20 Gbit/s bus (~2500 MB/s over a 20ms window) indicates the
buffer should be at least 50 MB. The new limit of 64 MiB covers that,
plus a little extra for any overhead.

With this change, both users and developers should now be able to debug
and reverse engineer modern USB devices even when running unmodified
distro kernels.

Please note that this change does not affect the default buffer size. A
larger buffer is only allocated when a user explicitly requests it via
the MON_IOCT_RING_SIZE ioctl, so the change to the maximum buffer size
should not unduly increase memory usage for users that don't
deliberately request a larger buffer.

Link: https://lore.kernel.org/CAO3ALPzdUkmMr0YMrODLeDSLZqNCkWcAP8NumuPHLjNJ8wC1kQ@mail.gmail.com
Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/CAO3ALPxU5RzcoueC454L=WZ1qGMfAcnxm+T+p+9D8O9mcrUbCQ@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mon/mon_bin.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 4e30de4db1c0a..dabe1a5c6ae56 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -68,18 +68,20 @@
  * The magic limit was calculated so that it allows the monitoring
  * application to pick data once in two ticks. This way, another application,
  * which presumably drives the bus, gets to hog CPU, yet we collect our data.
- * If HZ is 100, a 480 mbit/s bus drives 614 KB every jiffy. USB has an
- * enormous overhead built into the bus protocol, so we need about 1000 KB.
+ *
+ * Originally, for a 480 Mbit/s bus this required a buffer of about 1 MB. For
+ * modern 20 Gbps buses, this value increases to over 50 MB. The maximum
+ * buffer size is set to 64 MiB to accommodate this.
  *
  * This is still too much for most cases, where we just snoop a few
  * descriptor fetches for enumeration. So, the default is a "reasonable"
- * amount for systems with HZ=250 and incomplete bus saturation.
+ * amount for typical, low-throughput use cases.
  *
  * XXX What about multi-megabyte URBs which take minutes to transfer?
  */
-#define BUFF_MAX  CHUNK_ALIGN(1200*1024)
-#define BUFF_DFL   CHUNK_ALIGN(300*1024)
-#define BUFF_MIN     CHUNK_ALIGN(8*1024)
+#define BUFF_MAX  CHUNK_ALIGN(64*1024*1024)
+#define BUFF_DFL      CHUNK_ALIGN(300*1024)
+#define BUFF_MIN        CHUNK_ALIGN(8*1024)
 
 /*
  * The per-event API header (2 per URB).
-- 
2.51.0



