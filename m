Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143253054EA;
	Sat, 25 Oct 2025 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409394; cv=none; b=gAHq9mMeFehHvrzlbPV0l49grdPrdQOx2UiilGN+sMWNx63VNT/d1eHlyHehGXoBD4RTT1d0G8RQDkDH5FpqO1XfRfwRJGXtbqQsT4+ZDlEMjy8ZL5go7c3rTQ8De26dJnyizcB28XNPWXVsnKatS+4bjljl1QpQMjgLxRnNBeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409394; c=relaxed/simple;
	bh=0dgm1PCT5hqrnGy8K3SUIyP+dhoW5u2Azx/rz4AMqPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PRz0bQaPmWyNiligopZheBichXBo/hgDq2xmSsr8GnX3t7Tktr/sqkRPFaQjUSNuxlZcW2QzyGseUyJdAmpjXzWgAQ5bbPPYD0miw9AqFHB3z5FarBlHlaKp580+Fpp8/USzyF/Xk6LCg75A8wdzHAagcF6Hco/lEmwaUN9Nx/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0GPG4Nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0GPG4Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5B1C4CEF5;
	Sat, 25 Oct 2025 16:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409393;
	bh=0dgm1PCT5hqrnGy8K3SUIyP+dhoW5u2Azx/rz4AMqPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0GPG4NfUwwBVVGuTZBbg4TXQO7+pF2QEMavSN2vsXCtQXAJDEEtgfplPYMRWCPAX
	 0aE2UBlrY38agbEJsmNi8SY20cmYZ1gse5j1m0Fglg6iQjjlJCtwFzij2X9k+0RNOC
	 68gKDKJUFTmWehkkvnM3sESEJkK470ddWjPGIAnDJNgncAoxGazP4i375IxplYhb/A
	 Y13yx2ABAYB1m1T0Z1El61DtY5HdkaW4zAYxYOOE/5Yxm0oXDyENuWr4hWm6gFL9wH
	 QzxJWY+iMQ60nYjE0AJjpy9Wv214Vn5eUIXg9u3rEBvf3UBfSpTDo6HIwjnYlWv6Lz
	 NkWRrlBAPTJcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Forest Crossman <cyrozap@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	snovitoll@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs
Date: Sat, 25 Oct 2025 11:58:55 -0400
Message-ID: <20251025160905.3857885-304-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES: Raising the usbmon ring buffer cap restores capture fidelity for
modern high-throughput devices without altering default behaviour or
introducing architectural churn.

- `drivers/usb/mon/mon_bin.c:82` grows `BUFF_MAX` to 64 MiB, matching
  the commit rationale so the per-event limit (`b_size/5`) now permits
  ~12.8 MiB URBs instead of ~240 KiB; this directly fixes the real-world
  truncation that blocks Wireshark and similar tools from reconstructing
  higher-layer traffic (`drivers/usb/mon/mon_bin.c:535`).
- The default allocation stays at 300 KiB
  (`drivers/usb/mon/mon_bin.c:83` and `drivers/usb/mon/mon_bin.c:705`),
  so systems that don’t explicitly request a larger buffer see zero
  change in memory footprint or behaviour.
- Larger buffers remain opt-in via `MON_IOCT_RING_SIZE`, and the
  existing `BUFF_MIN/BUFF_MAX` range check simply accepts the larger
  user request (`drivers/usb/mon/mon_bin.c:1017`), preventing silent
  over-allocation.
- Allocations are still paged and freed per chunk
  (`drivers/usb/mon/mon_bin.c:1338`), so even a 64 MiB request is
  serviced through order-0 pages with graceful failure on ENOMEM; no new
  hot paths or locking changes are introduced.
- No other subsystem takes dependencies on this constant (history shows
  it was static since usbmon’s 2006 introduction), so the change is
  tightly scoped to the usbmon debugging interface.

Natural next step: 1) Run a usbmon capture of multi-megabyte URBs (e.g.
USB 3.x storage transfers) to confirm end-to-end tooling no longer sees
truncation.

 drivers/usb/mon/mon_bin.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index c93b43f5bc461..e713fc5964b18 100644
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

