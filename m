Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE8419FBB;
	Fri,  4 Sep 2026 05:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499396; cv=none; b=O8a0+1O+54qohnjs7mdxm46L7gfTSQQRthjISpjhIGdjtyMfynqGnial+mjzVMIFTtr6FupTyxppdK/hHr0eth6hP5dKFZtY2T723FBeVJ8TImaZCaFSmF99Eb6sJKnASiSdOkA4vhfq77KRIWc5Xb5xz4gebRAUNaAArzA16Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499396; c=relaxed/simple;
	bh=JdS3w/S6FaedpyiXIqPrWUmIUapLjTz/17rERE6MPnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyiA5eztySoaFW67cg/TAvZXysdpozJGKUy/ZLXRrlWHNgED89WHwSRk5FOu17gd15IrXhPjGINQZmKkH5Ko/L+P8jIJHlmBWw4blUK7w90mKrvm03sN84biWiLHf39E82f2GNDFr0EfA+2JR7uvcV8WxPpm/gUHAqTOFVEgcNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWMHCx9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWMHCx9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C841F00A3D;
	Fri,  4 Sep 2026 05:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499395;
	bh=N/6zER8PAYY4n5pyWmLZ/OvW5j1zd1FOMbTmCOUYDik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWMHCx9OKzcoAT4UhHhstFqrq4mxXXj8Z8bpx9oITKu7fY+ZrTnEfGPmJn78pio0z
	 2fSQjMXO7f3p2JE75WZvSy3Ctkkx06GZYEdZRUUzYH7fQE8oCDzqrNE6Do8nuuu75K
	 jmQ99GJMGRyTP+xA5YEL5MFo6uejOYlLazxgIO8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 7.2 359/713] libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
Date: Fri,  4 Sep 2026 06:55:27 +0200
Message-ID: <20260904045811.876531030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 037770686126155eafc44501312989e2837b9659 upstream.

The on-media namespace index field nslot is a u32 read from the DIMM
label storage area.  __nd_label_validate() bounds it against the config
area size, but sizeof_namespace_label() returns unsigned, so the product
nslot * label_size is evaluated in 32-bit and wraps modulo 2^32 before
the comparison.  A crafted nslot passes the bound and is then used as the
loop trip count in nd_label_data_init(), whose memset() walks off the end
of the config_size buffer: an out-of-bounds write.

The field is not trusted -- it comes from the medium, or from userspace
via ND_CMD_SET_CONFIG_DATA.  Evaluate the product in 64-bit so the bound
check is exact; conforming labels are unaffected.

The check was safe when introduced by commit 4a826c83db4e ("libnvdimm:
namespace indices: read and validate"): it multiplied by sizeof(struct
nd_namespace_label), a size_t, so on a 64-bit build the product did not
wrap.  Commit 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label
definitions") narrowed it to 32 bits when the label size became a runtime
value read via sizeof_namespace_label().

Fixes: 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
Cc: stable@vger.kernel.org
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260624-b4-disp-d8279485-v3-1-cdb6cab28b41@proton.me
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/label.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -202,7 +202,7 @@ static int __nd_label_validate(struct nv
 		}
 
 		nslot = __le32_to_cpu(nsindex[i]->nslot);
-		if (nslot * sizeof_namespace_label(ndd)
+		if ((u64)nslot * sizeof_namespace_label(ndd)
 				+ 2 * sizeof_namespace_index(ndd)
 				> ndd->nsarea.config_size) {
 			dev_dbg(dev, "nsindex%d nslot: %u invalid, config_size: %#x\n",


