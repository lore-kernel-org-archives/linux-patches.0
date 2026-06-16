Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5880636E47E;
	Tue, 16 Jun 2026 17:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629906; cv=none; b=oLGE07GhgELe1mcSk6xgeqPZqRHLsDSy7PEhUyMx26OZB5Z66ngr8FX7CuRYQ6HwtVGEr5fz9EW9JY3TDx3abrwuUlEAaLcn11yIRNnt1XZPuGATPVS3xPhu8mJLW+Z3LPb3J9m54P8jrWz/YgGCjFAcDxIZKE2aBAuNxLHIDGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629906; c=relaxed/simple;
	bh=xWYHxaxLdC/z7rU+pWmnEU4R00ZwcIjhXuk37GV1I7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4fqyPrlH5QEqjplTRkJdvDp/AT4KJ3rfEr7ZE0uJ6Eswqk7jOUE8Z0L6bA9slmkNl7Og4Gsz//0OYnczj1hfbT1xdKHJxXZUsOszhRa56GW8cp88qDpXczgxDQGmshFTUA19DTSQqSwnEomBvzionWojzD8hlBN9Mi/gSKsvtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/72mxwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/72mxwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53ADC1F000E9;
	Tue, 16 Jun 2026 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629905;
	bh=v+AgL5KhAM/c40nC/6dAFAe6UaUCQaihXF4IJnUK86U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/72mxwfKIf9a255oElGD0U0jrrdHHQbrHEtNxO+tr+Sf3wiQDtdJJNeKQ6cVBYRv
	 hrZ+hr0QUqCxqVPHrq5fpWhsuwrBAACbwlwYJyG5pt8KB2yyMVlJtzlsMn6GL5G/1o
	 /uEIEf1Ni47VSnEQ2qdi55ioI85wmUD5zXCKRWO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Andre Heider <a.heider@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 341/452] nvmem: layouts: onie-tlv: fix hang on unknown types
Date: Tue, 16 Jun 2026 20:29:28 +0530
Message-ID: <20260616145135.202538644@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


