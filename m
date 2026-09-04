Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BA14156F9;
	Fri,  4 Sep 2026 06:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502395; cv=none; b=elUb+mHuedixFmLjAvbE9WHKx4X1JMOJMcTdm0i72F4HOi0GG94d9C+9MGhT+59HnsMDPDO6/E5Hp+d3KEIAvlPGtI1lZuPLacYujiMmk9bYcVRXEmyouSTVX7/fb2HwjzfE5qbwqOSXwzK2d1mya3NaeXD/tCqIvyKK9AH/shM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502395; c=relaxed/simple;
	bh=d+tuBYOmCkcpOOos8Vc/Y0HVuXIMwNrDHaZ7j/1BGMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URtqI+nJXjcRR74MGTr5TWNBr6hNbYKa2h14PX1f3ePPLEtES/ZO9quQUHpHHt4QPzL5xJU/ognpTu0/E6hkU9Ae+iNFq5U1YAA/TQgTyW6AI1Wcj/V0598siUl3wB8vhJu8XpsTY6/Iqb2wIWxkvN5nFfvgVtT3n1bTAEJPGnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKxqMQIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKxqMQIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BACC1F00A3D;
	Fri,  4 Sep 2026 06:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502394;
	bh=qY9wORsJOE3rVjnmtG9mPnrYdaqVRroLL4rbrMbQnK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKxqMQIjh60NZ5vIUkwbHuCzGKDwO1MaxYaL2GkiHS8c0QbRSjtOxoikOiqSwqvzM
	 ASh1DIWrLBxFFYoKMC4i5mO2yTR2tPA7ERic1CYGePJlaCc3oOO4HMA2e8wqtG0trI
	 3tIjUFllEMumZFfylfDwbUQWZ47s2rU15rEHErUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 6.12 193/403] libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
Date: Fri,  4 Sep 2026 06:59:56 +0200
Message-ID: <20260904045739.243759539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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


