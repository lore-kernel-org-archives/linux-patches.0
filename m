Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C6544BCB0;
	Tue, 16 Jun 2026 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624226; cv=none; b=jwpZ2ZuEbiNjItXPmSxtBvKmP0A7J5TMvhEz6FPRVSfI07qbgOBGC9JxiZO3vakUJuyapsmzv1wx4dULHYERBKtlDgpFDBSvtaRy4PcnzjgxDo3TnWsy5XAAefZCiHZDhQovUhePanVqk31Uo/Cmm7eUjm86uq8XIjDO8ugAD7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624226; c=relaxed/simple;
	bh=TSmged4tdxUG2a9JsFVUIkMNO9gJ3ebGfCLa0DR/4G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMM0WKBgiJna/ARN+0aObjkbvCGGR5V78ekw5aGc3CpNnREpAX/PT82LjPJJdUpLpc7dts0Fa+a0YRvriArmp+AffVemjcLlQOmo8hWwEo57ljfRr3b7WG6QZ5oEXNBoQJXAhk/gU6V/Hr4rjAH8/hHuZeXS0mRTOsViEapGxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBcL0aAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBcL0aAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0341F00A3A;
	Tue, 16 Jun 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624225;
	bh=z1fD4P1Stsk+Z6E430S7KrkuCwu15b7kck0Bsbmde1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBcL0aAu6povUrElsUsEVhBwqulPUYsQTn/5EBd2ZUxf2u2pp2ChiD561P8FHFNqK
	 dRsRsS46+c5F6L+XXReVhB3egbUUh2t49wL2/TLuPE0NTm+DWUpEbJlbBmCArAb2Ub
	 rZ6C+mihpmTBYTyo0fR6Wz/PEcGOP79GeaMcAAt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Andre Heider <a.heider@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.0 295/378] nvmem: layouts: onie-tlv: fix hang on unknown types
Date: Tue, 16 Jun 2026 20:28:46 +0530
Message-ID: <20260616145125.589210554@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Andre Heider <a.heider@gmail.com>

commit ea41020b9018e31c2ea7e9d89021e3e6d7470883 upstream.

The EEPROM on my board has a vendor specific entry of type 0x41. When
stumbling upon that, this driver hangs in an endless loop.

Fix it by keep incrementing the offset on unknown entries, so the loop
will eventually stop.

Fixes: d3c0d12f6474 ("nvmem: layouts: onie-tlv: Add new layout driver")
Cc: Stable@vger.kernel.org
Signed-off-by: Andre Heider <a.heider@gmail.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204340.116743-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/layouts/onie-tlv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/layouts/onie-tlv.c
+++ b/drivers/nvmem/layouts/onie-tlv.c
@@ -119,7 +119,7 @@ static int onie_tlv_add_cells(struct dev
 
 		cell.name = onie_tlv_cell_name(tlv.type);
 		if (!cell.name)
-			continue;
+			goto next;
 
 		cell.offset = hdr_len + offset + sizeof(tlv.type) + sizeof(tlv.len);
 		cell.bytes = tlv.len;
@@ -132,6 +132,7 @@ static int onie_tlv_add_cells(struct dev
 			return ret;
 		}
 
+next:
 		offset += sizeof(tlv) + tlv.len;
 	}
 


