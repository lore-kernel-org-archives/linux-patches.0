Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824F61C6F76;
	Tue, 27 Aug 2024 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770896; cv=none; b=ReZ/gF/fLUkCpyeJ89JN/G/rRBYPQiSVZIVfEllFlAUedTy1mM+CeyiQ1cqM4ccfS+IQZAQKYtpa1+dIbW4B4SXuqgoKQqTyN/3xdC/fubhwBkR2u+MJUr7NPfpE2HTfS/XaK+LP12uZvnt3Yvg0mD5B8kVqF8bP8XXB1QxeQo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770896; c=relaxed/simple;
	bh=rbDQzMb8H5X+vCwv8rsMkcoLBa+kCPMgY9agJZa/068=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDHtghrbxVpb9eyw/K6TADYjt3chYBjtOpxswiyHg2PZ33BEkdyztG29WPLZR3cbQu1+IVV+OkjjQI2ymdYa81JDJvzr4vE9MY0k7kwX9B2j3Gg4BFHZFnmy71RIbpuF1c9i1TkpA/IPz+qT/rKEk/7u9k3NWJ+BtGdezbnnBD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMiQDSOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMiQDSOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03606C4DDEF;
	Tue, 27 Aug 2024 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770896;
	bh=rbDQzMb8H5X+vCwv8rsMkcoLBa+kCPMgY9agJZa/068=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMiQDSOCgVIoquMnf5AZrUUKQh9Gpo92o/lcveiGdwekpeMT6IkwWQJDSAMetW9gQ
	 BCEtdAPtRVQ5LKwnIjWoYvc/El8TNATbnUzVmHQW8ccx6hB70X1/zZNyf+Ucx7B0jK
	 aUmYl9LkXHkcaMwSrF8iFsNNcl++y+oteMNFV98E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	kernel test robot <lkp@intel.com>,
	David Gstir <david@sigma-star.at>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.10 025/273] KEYS: trusted: fix DCP blob payload length assignment
Date: Tue, 27 Aug 2024 16:35:49 +0200
Message-ID: <20240827143834.347793319@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gstir <david@sigma-star.at>

commit 6486cad00a8b7f8585983408c152bbe33dda529b upstream.

The DCP trusted key type uses the wrong helper function to store
the blob's payload length which can lead to the wrong byte order
being used in case this would ever run on big endian architectures.

Fix by using correct helper function.

Cc: stable@vger.kernel.org # v6.10+
Fixes: 2e8a0f40a39c ("KEYS: trusted: Introduce NXP DCP-backed trusted keys")
Suggested-by: Richard Weinberger <richard@nod.at>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405240610.fj53EK0q-lkp@intel.com/
Signed-off-by: David Gstir <david@sigma-star.at>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_dcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_dcp.c b/security/keys/trusted-keys/trusted_dcp.c
index b5f81a05be36..b0947f072a98 100644
--- a/security/keys/trusted-keys/trusted_dcp.c
+++ b/security/keys/trusted-keys/trusted_dcp.c
@@ -222,7 +222,7 @@ static int trusted_dcp_seal(struct trusted_key_payload *p, char *datablob)
 		return ret;
 	}
 
-	b->payload_len = get_unaligned_le32(&p->key_len);
+	put_unaligned_le32(p->key_len, &b->payload_len);
 	p->blob_len = blen;
 	return 0;
 }
-- 
2.46.0



