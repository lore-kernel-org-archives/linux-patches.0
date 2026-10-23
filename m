Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774374;
	b=L4shgBI6aG2eZ5jbk9lAPwuc6A5ldpCd2AcLoK0Fx3DbORO13TGaajEil8NX3B5Nn6k1
	 sYCbJvQMZJOQGZnbL4g8Huk6R7qF7Y2QScmUHvOnbGyke4W6IiF35Gp8KoTr6MA1V5EZk
	 UOI1pV93NhMEy6LRSu82wOwOukUUWaOcVKVS5yPakRtw7OE4kBOquJLi7IxyDC0iOGV8b
	 KdquWNzDcsF3ywdAPicLSg5Daba/2T/N4joQw/QicH8V722SiZ4f38S1tDG/1mMV8x6Tf
	 WeE9ORT/Ei0Wv+ZMyoZ4oON6M3t0mw2TWDQmcCjIQAH3DquLDrdw2xX64N4RAhQgXzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=difYk+y5KwUYfkZVQ9unGR5ILF85+DOGg1r40xUFFHs=;
	b=Oe2+/D0bJ0BwUHbOwQe29OIpFV1XG/rbBtxDvh6jKs1NzJjC4oBjwU1DGfoW9WZ8YPVw
	 Y9bsbVtgwb/vgmEGv52Gt/kvIDLVTWrMVeAo2EwU75uWgtJMFKTeLfWp7xTSBPMGOqdp5
	 68uVuA0KlLtvS0u917E4O9+P67ZXJtJaVrJIl/uEDVa3XUhGkrSURWKHKeOZ4Be4C9lnk
	 xHAODUZclNbOGIKALVgpzcV6yPUvasxf8+0llLBR1+QebCjzXBKWZtDZv4Os+mZgPIdZi
	 f4JPX1LG3SreOV2ULpSYC9n+beBhpVLCtCAB1fjl84Hk36RzPXNa4fxgMwkEvNNAZtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=abYJMJ4v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE28606A31B;
	Fri, 23 Oct 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=abYJMJ4v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1FF1F01825;
	Fri, 23 Oct 2026 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774374;
	bh=difYk+y5KwUYfkZVQ9unGR5ILF85+DOGg1r40xUFFHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abYJMJ4vLiWkBOY7zLDum61Le8f7QhXz1IHMm6Tz3MmcDyMp/z4yjJz3dfdqgWtAL
	 8SU9IxWr6eNgQ3yhjCoKDZycUY6AuwLoWfRA1eMOQ6Xly5zXuvyP3AC+3Cyzg/Q3Nd
	 MTKS+jiSHlFz0zuvcppjuO+90WDCwf9yDN7tFYQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 020/242] tools/power turbostat: Fix PMT error path fd handling
Date: Fri, 23 Oct 2026 18:37:42 +0200
Message-ID: <20261023163714.260994048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 11741cc90f9176746b8595beab4fec8d736ebd18 ]

It is possible to leak a file descriptor if a diretory
open succeeds, but the scan fails.  Close the fd on error.

Also, on cleanup, check for NULL fd.

Assisted-by: Claude: Claude Sonnet 4.6
Fixes: 4265a86582ea ("tools/power turbostat: Add PMT directory iterator helper")
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 01644d858a98f..40f5f9a9e950d 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2034,8 +2034,11 @@ const struct dirent *pmt_diriter_begin(struct pmt_diriter_t *iter, const char *p
 			return NULL;
 
 		num_names = scandir(pmt_root_path, &iter->namelist, pmt_telemdir_filter, pmt_telemdir_sort);
-		if (num_names == -1)
+		if (num_names == -1) {
+			closedir(iter->dir);
+			iter->dir = NULL;
 			return NULL;
+		}
 	}
 
 	iter->current_name_idx = 0;
@@ -2063,8 +2066,10 @@ void pmt_diriter_remove(struct pmt_diriter_t *iter)
 	iter->num_names = 0;
 	iter->current_name_idx = 0;
 
-	closedir(iter->dir);
-	iter->dir = NULL;
+	if (iter->dir) {
+		closedir(iter->dir);
+		iter->dir = NULL;
+	}
 }
 
 unsigned int pmt_counter_get_width(const struct pmt_counter *p)
-- 
2.53.0



