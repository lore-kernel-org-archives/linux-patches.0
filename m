Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCD84C610;
	Mon,  8 Jan 2024 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ivPUnPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE666C43397;
	Mon,  8 Jan 2024 15:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726948;
	bh=cdvSfjeqmniaQjHkK8ll/9mkUEtWBLGKGWIb3kXBXBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ivPUnPCkHsebaSgSeB/1LLtbyAlAPHLiYd5cdaB3u8Leg9Yi7mOVNXG4VttpEBFN
	 gebmvvx8A0SAuqSa8i6TEHumKwxBSEm9vJ7TCQIUaijYYJt09S00UMgb7HKXzhJuR7
	 xv8ozMsmXDm1WK93+Dco/qKKO+gKHjPWsXiYNOdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 122/124] cxl/hdm: Fix a benign lockdep splat
Date: Mon,  8 Jan 2024 16:09:08 +0100
Message-ID: <20240108150608.579516704@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit 36a1c2ee50f573972aea3c3019555f47ee0094c0 upstream.

The new helper "cxl_num_decoders_committed()" added a lockdep assertion
to validate that port->commit_end is protected against modification.
That assertion fires in init_hdm_decoder() where it is initializing
port->commit_end. Given that it is both accessing and writing that
property it obstensibly needs the lock.

In practice, CXL decoder commit rules (must commit in order) and the
in-order discovery of device decoders makes the manipulation of
->commit_end in init_hdm_decoder() safe. However, rather than rely on
the subtle rules of CXL hardware, just make the implementation obviously
correct from a software perspective.

The Fixes: tag is only for cleaning up a lockdep splat, there is no
functional issue addressed by this fix.

Fixes: 458ba8189cb4 ("cxl: Add cxl_decoders_committed() helper")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/170025232811.2147250.16376901801315194121.stgit@djiang5-mobl3
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/hdm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -848,6 +848,8 @@ static int init_hdm_decoder(struct cxl_p
 			cxld->target_type = CXL_DECODER_HOSTONLYMEM;
 		else
 			cxld->target_type = CXL_DECODER_DEVMEM;
+
+		guard(rwsem_write)(&cxl_region_rwsem);
 		if (cxld->id != cxl_num_decoders_committed(port)) {
 			dev_warn(&port->dev,
 				 "decoder%d.%d: Committed out of order\n",


