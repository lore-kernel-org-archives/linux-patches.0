Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C2313B2B9;
	Tue, 27 Feb 2024 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042926; cv=none; b=uJZBxrHfQjePQTU/XHD2vM7UAtt74iqCrai1cEUsaBptlgPrN2JlIPZE9rcXPwHm8jXX6v5/zkojC5Qu1LNuFhaZcTG80elWr9IWRrqSmDzIWEKdNEROC5y8hvt/6LgobbI5UBScH3e2fme1mY+ABq+5pSFPoue0GcX4mjTdRto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042926; c=relaxed/simple;
	bh=0drjwJSdzUMmVXMFmFflNdUWRqZgT7Oer6ppKgyab1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCssOV/kQLDhzBGJyW6meNiXkrwv/BS0o1QcnOmQiOKVUpgB8yE1UkjzoI3IZJSTA3libY/p5FVXjWO5JJj2pL8S5obHVqxAhsVx+zqj/QmAKuu0A2wZUpOsL1k3lHz2Dwo2yijSwLUC7g4JOR/HzLzxKFnAv8v5F+S1yXSTpu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/y91JX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/y91JX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87763C433C7;
	Tue, 27 Feb 2024 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042925;
	bh=0drjwJSdzUMmVXMFmFflNdUWRqZgT7Oer6ppKgyab1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/y91JX7aXUZga47Mn/uzd8JHvB7HYSgN16Dv9PQSlWsL/TeyjQoFPaCWAYXuVgKI
	 X3Ta6jd5qnWTkINKtTXpjF9qwkNyYXrxheSWgQeAGhR52K4EZp2NxgvvPp3eGT8pwO
	 MJm4I54bqQHwxyHkL428qeQxrIpGhDyPqtGJARug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/245] btrfs: add xxhash to fast checksum implementations
Date: Tue, 27 Feb 2024 14:25:58 +0100
Message-ID: <20240227131620.736214736@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit efcfcbc6a36195c42d98e0ee697baba36da94dc8 ]

The implementation of XXHASH is now CPU only but still fast enough to be
considered for the synchronous checksumming, like non-generic crc32c.

A userspace benchmark comparing it to various implementations (patched
hash-speedtest from btrfs-progs):

  Block size:     4096
  Iterations:     1000000
  Implementation: builtin
  Units:          CPU cycles

	NULL-NOP: cycles:     73384294, cycles/i       73
     NULL-MEMCPY: cycles:    228033868, cycles/i      228,    61664.320 MiB/s
      CRC32C-ref: cycles:  24758559416, cycles/i    24758,      567.950 MiB/s
       CRC32C-NI: cycles:   1194350470, cycles/i     1194,    11773.433 MiB/s
  CRC32C-ADLERSW: cycles:   6150186216, cycles/i     6150,     2286.372 MiB/s
  CRC32C-ADLERHW: cycles:    626979180, cycles/i      626,    22427.453 MiB/s
      CRC32C-PCL: cycles:    466746732, cycles/i      466,    30126.699 MiB/s
	  XXHASH: cycles:    860656400, cycles/i      860,    16338.188 MiB/s

Comparing purely software implementation (ref), current outdated
accelerated using crc32q instruction (NI), optimized implementations by
M. Adler (https://stackoverflow.com/questions/17645167/implementing-sse-4-2s-crc32c-in-software/17646775#17646775)
and the best one that was taken from kernel using the PCLMULQDQ
instruction (PCL).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9ae7c12668cda..c1dfde886b1e3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2338,6 +2338,9 @@ static int btrfs_init_csum_hash(struct btrfs_fs_info *fs_info, u16 csum_type)
 		if (!strstr(crypto_shash_driver_name(csum_shash), "generic"))
 			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
 		break;
+	case BTRFS_CSUM_TYPE_XXHASH:
+		set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
+		break;
 	default:
 		break;
 	}
-- 
2.43.0



