Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E918E352032;
	Sat, 12 Sep 2026 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232888; cv=none; b=IYGVbFReQe9twO/R8yBD3QK2+pLBzjXMOshLVnU1ej2uA/Fqfuo7Q1tmrhdxwGUjoNTXrsoFJ3Iu2rVvBDbizxGAO/y4zURm0AU9n2MuA/kbUL9GPJ1A1j3bCIZZ04czxGI4/XpFetxs9HHaUT9EbWVVXDamAO7h1/CE6gIG+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232888; c=relaxed/simple;
	bh=HNhGXStJLtrl9d44CGVSx4zAWPZPbdR6UHlGa+ix2IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbhnKyarvkY0nKPfRcMjZhbNXZJa4Io5bGal8ImnkZ+ok7Gq+rBGr1GcFK97y7p20qRcWEitmwxgQwXKI7Qe0P3M3EI/pnd8a60241dFG/aw9jh4+hEPgnUm9dt0prpunfFfmdR0pzSQPhqzEpl7m06C7PwBBMBtI985CFLtfkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqUpKvgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqUpKvgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BB21F000FF;
	Sat, 12 Sep 2026 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232886;
	bh=apyvkv7MPGWY1nb+6ZPSb3J/1qGnTmQOKKDTs+FExbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqUpKvgORDGiSLOiI3GpQuY9ze4hmsPuhHYJmolUIvYeMTOzhoAt8N9WXD6R4lJRF
	 yLbvdBFlHn5C/0Pq9+NkAOFHKFoTmqK0nzvo1PTCpX/p+KsRXc+6PPRmz0DJXiMqMt
	 8QxU66pR0tkvf0YOiZBgYWUy6b+6CBfe1oKtxCjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 5.15 102/935] libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
Date: Sat, 12 Sep 2026 08:52:12 +0200
Message-ID: <20260912065529.159906791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -194,7 +194,7 @@ static int __nd_label_validate(struct nv
 		}
 
 		nslot = __le32_to_cpu(nsindex[i]->nslot);
-		if (nslot * sizeof_namespace_label(ndd)
+		if ((u64)nslot * sizeof_namespace_label(ndd)
 				+ 2 * sizeof_namespace_index(ndd)
 				> ndd->nsarea.config_size) {
 			dev_dbg(dev, "nsindex%d nslot: %u invalid, config_size: %#x\n",


