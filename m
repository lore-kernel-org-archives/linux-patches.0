Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070B334216B;
	Wed,  3 Dec 2025 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777838; cv=none; b=LSkOGvUJYm/vsxQISl20L8sWOkN25sSTq40z9SK1aotIx+QPYt2SEabhRPTv7Z7MGPZzQfY4Be8kNTl944KakC7iwNoFWqvEDboLj+OdJGYEAD/oKZWGe+WgWBFa0ehfA2JtQxQlMLwLMfe4MDAXYovInajd9zr6fhcU6UTl7y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777838; c=relaxed/simple;
	bh=EdqbA/OSWt0DUMFb8lN08MsiAo8gy9ozy22phykx4bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRKOJI5rZOLMWHCxv41zUC4dBnrSZbUcl+LJ1hjWfxGuE/yH+rwath5rt5Upqqs/eicetxoAhOcRRLHybyCGGBJAk8M4+ba5fz7d3nFBZ2LTRMwNL/hysAFBoYyT+IYoo2G+r1uyn+J50PZTXq+6gype72cRdy+KzujbV04Zv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6kR5vXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6kR5vXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C32C4CEF5;
	Wed,  3 Dec 2025 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777837;
	bh=EdqbA/OSWt0DUMFb8lN08MsiAo8gy9ozy22phykx4bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6kR5vXP1dtnsSk92gElRY49XsTMXjag18W8pOe+l++ZbAI5fEk6W2+h57xxBUbAz
	 WOc6BI3J0/mC+ZzJ7UWhXok0piUqn+WvX80smav5fSTkP+e2Dkq5zcpxF1nVHzPwYE
	 BJqm8Hj7xT+ZKW0WdMEOrydTUP0axzMWkd6N8aPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Forest Crossman <cyrozap@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/392] usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs
Date: Wed,  3 Dec 2025 16:25:11 +0100
Message-ID: <20251203152420.004209158@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35483217b1f6c..93998d328d9aa 100644
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



