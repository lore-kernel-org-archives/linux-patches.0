Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBD8477990;
	Tue, 16 Jun 2026 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627522; cv=none; b=UaYhTOfNnoCWBt0JRFDEBGeqtFOQ+W4zPITs6SEa4QF6kN0/1I7zej6Q0TqFplfBmh77oNx2umuGiQPWKzdime4w18E+5I+BVkqgT5Kx7421DY7Bp9aoS1mM7ScO06noymOXtSZ0rST93SDMIdmdvn/bExGEGAI7s7pAXgEIvF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627522; c=relaxed/simple;
	bh=HRQ9lAxtSyftjiu8avwHvrSXhfimwx2HWUJnn7qrXHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fdn9O7Iji0ve68gtrtIVR5QXGeOhET3wXtIFL7kI4ENSjoIy1eA3PV88ADcxW6952GBNmOjMBxdzHohydJVO/lSAmOaMwIb7da8BNA+we/YPeX3uJgrheK8Z/d/pEHw+Uvt2BnAw8eUO0AYdHgKsMIXlvC6cH1Sb8UZ+55r85KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJy+fP1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJy+fP1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B891F000E9;
	Tue, 16 Jun 2026 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627520;
	bh=fcHf79MeZpatl6wskP3UVfWyzrf1fX+o6tOiZRwIyYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJy+fP1RvS4KBQGCwoTMNDr0Z51lH7xb0kYotoXLgkvUFkzm14ho9imUwrP9K7eZl
	 bfdkmeSo0ujwNUViE0aW6b3L6yF4/A8aPyjdRvBbtXLK7C/MmptzinP2EScWG4nlHs
	 1aGqP18kZcmxK8yOiWysVIgHhDq4gcvbGQbxpZc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Andre Heider <a.heider@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 187/261] nvmem: layouts: onie-tlv: fix hang on unknown types
Date: Tue, 16 Jun 2026 20:30:25 +0530
Message-ID: <20260616145053.733435941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


