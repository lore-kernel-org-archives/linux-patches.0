Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3023418A5B;
	Sat, 12 Sep 2026 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220274; cv=none; b=GmetnL0c4C0xmggC7HXfi1BUd2gY8nijBMKLAg36HzWsVzgay7bJeLVzLqKLpFMBzLhy5uXgYStgeEwlbwoapxzKI1HV2+y/ZNnzA0lClsFq2eREo8trDE4CeUMB9pyDiJ6984qtTU+iNN7kATz8LC5vyeDIF4dko5bkyXi+5lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220274; c=relaxed/simple;
	bh=sr/DzvzYLFW2HICfTBjzOIxtv8WC2zKEA1Z+7k7fYk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVvgn77lVqDricaE/hMY/bvqO34ShWNmPBKrHrbKMpxL0zHobXE2ELDowfaM+wfN1h9d2TPSkZnBY9pLldO52JaETmScF9UaPqzHK5P4oPi15pRvaV4QI37wO+bZ5QFeslJlP/WZCknN+H8kBopo9VUVpgug9r3PWHag6FJ54MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waDRSu4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waDRSu4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ED71F000FF;
	Sat, 12 Sep 2026 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220273;
	bh=RY+KBjmqQrshocfaEiJ+8iVkho6nQkbZ6h1rU8zF13g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waDRSu4oE74Ia3cb0MNhlmf3lmbmqKGykdkJWQveMqzVfWlk0cCk5cf6Q3GN9D8fb
	 D1gZwI9FqaA/qJtXtO6JON6DD/O/fG3U6uKHF3/wSB1SPkDhB5jdEEFQUSczBofkXo
	 gL8lyg6VWwoA8zKaZcKr0N2a43fRzshwmkZINJAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 6.6 0143/1424] libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
Date: Sat, 12 Sep 2026 08:42:55 +0200
Message-ID: <20260912065610.501054542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


