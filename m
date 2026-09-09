Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5900A58B6DC;
	Wed,  9 Sep 2026 14:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963521; cv=none; b=q9MNkJyLVrCT0cxZBRQsQjKCsyNCKchFVHzcZSm1mgk53Jx61+PLDjcfNQfNzCxR7rXuuxWOwuWcHjP/1py666NINcI4mNUzk/QjLEL+7KyxqSmRbzhsHVaF7MUwAtf0wwSzirnvsZ5LM9v3hVx2G/nu6ULofEyWodkN2l/VFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963521; c=relaxed/simple;
	bh=uEsxaQm85vUtHdoUf1agBdjvJkHcb2MsksEhrt6j/D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw5YTD16DObm7QSopsTykj6N7qe1lbhC2lc6V6Ra6MISIHjymX2PLIsjktwvBA/Gt53AZtegEgve+zoJXmyu6QAkZrCr/hgrd8Yf2UdcZHMAc0pLzIXgZrDY176SnectXetxFKaRfFcueQIhFesB+u3TqeEcgxL4iKJrzy8asXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkbRBW6o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkbRBW6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E081F00A3A;
	Wed,  9 Sep 2026 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963520;
	bh=I9X5SHQAPE/NHUnOlCzLo81EgnxO1OMru/D0uMYIZCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkbRBW6od8DL1z0Okg10ZDJZsM2s99aB/yvBvKIOQpLlHGCTU0dgqZoMHLC0SQesi
	 ztY+Qc/P1jBJIYteQV+/vDWxeurzkdvoAhLJBs35qiSJdzXyjdAV7bxFFYzl5H+k6g
	 3QYscRaxO2khDAwLgSDyahJshBfGZ1i3aND3tINE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xu Rao <raoxu@uniontech.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 106/583] nvme-fabrics: fix DHCHAP secret leak on parse failure
Date: Wed,  9 Sep 2026 15:36:31 +0200
Message-ID: <20260909134241.799874275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit afdee49a1b88ed9bb44e2b30e855297c169bcc53 upstream.

nvmf_parse_options() duplicates dhchap_secret and dhchap_ctrl_secret
with match_strdup() before validating the DHHC-1: representation.

If validation fails, the parser returns -EINVAL before the temporary
string in p is assigned to opts->dhchap_secret or
opts->dhchap_ctrl_secret. nvmf_create_ctrl() subsequently frees opts,
but nvmf_free_options() cannot release the unassigned temporary string.
Each rejected option therefore leaks one allocation.

This is easy to miss because valid secrets transfer ownership to opts
and are freed normally, while the malformed-secret path still returns
the expected -EINVAL to userspace.

With CONFIG_NVME_HOST_AUTH enabled, the leak is reachable before the
required-option checks and transport lookup. No NVMe-oF target or
working transport connection is required; for example, repeatedly
writing

	dhchap_secret=BAD

or

	dhchap_ctrl_secret=BAD

to /dev/nvme-fabrics deterministically takes the leaking parse path.

Free the temporary string before leaving both validation error paths.
Use kfree_sensitive() because the copied option may contain secret
material even when its representation is rejected, matching the
sensitive cleanup used for stored DHCHAP secrets.

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fabrics.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1028,6 +1028,7 @@ static int nvmf_parse_options(struct nvm
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1042,6 +1043,7 @@ static int nvmf_parse_options(struct nvm
 			}
 			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
 				pr_err("Invalid DH-CHAP secret %s\n", p);
+				kfree_sensitive(p);
 				ret = -EINVAL;
 				goto out;
 			}


