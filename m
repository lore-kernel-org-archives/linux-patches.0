Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC94E73C9;
	Thu, 17 Sep 2026 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658919; cv=none; b=Lr33736jPzBE3APzMKJEB19OkgZU6HETCoDWOFuI7/KRssDZ1pLYofdmmXpf3w1VnKtQs3FnNs0PvNgDdX+OYBHuPsvuLu9s7pJ3chkqN2HZfICb+6EnD8SXalvZCJZ2r++lIt9f/j03Unol3Vmj78WFQvwkrqxO0h6iiEkDXUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658919; c=relaxed/simple;
	bh=inEw6xEYQ7jnEARbGhtttlc0zaIPjPuXlPWY6O69oOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb7EECIMAg83jjA/FHi4Fz8Z73LXk0ArNxl6/BcO4nNiQaTNOwtLad1EaLeOyXxc1c1/HBJDnjx/yuGlxFrJ+lC58Awo+Pwvauuvp/Eb4j7VT+/Tr0SJRx4JRPrHAJFF95BwUfNEcqpa6iyoEkiT9wWj5sOUwKF8fuc4dBd8yUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBYQIzYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBYQIzYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67921F0089A;
	Thu, 17 Sep 2026 15:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658907;
	bh=lq7z+auJqJaYCV1cWSg8Xa4vhk8z7B+n5tWeEsM7us0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBYQIzYbrhH6FMNQWznuBqB1+Gial5d/Qr/SilnKlsQeW8OCmvoWuEBRFw3BDrzd2
	 tyczT5VdL6AA2LRvDCl4yzevEV32Xh/B1S5eCHm7wjtfvVonHW7WQ9+qsXgGOTZlTv
	 fRrN4wOJffPBKfEaqSLzUyPjXzz7uwFo4uPP1sQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 041/733] ntfs: return real error from ntfs_non_resident_attr_record_add()
Date: Thu, 17 Sep 2026 16:05:49 +0100
Message-ID: <20260917151351.781572692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit ba1b61ddaa764f31b14abe1d547049682cc5824e ]

ntfs_non_resident_attr_record_add() returns -1 at its put_err_out
label, which callers propagate as -EPERM to userspace.

Return the actual error code. Every path reaching the label has
err set to a negative errno.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index fbb1c5f4da18a..950fc1b727cb2 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -2634,7 +2634,7 @@ static int ntfs_non_resident_attr_record_add(struct ntfs_inode *ni, __le32 type,
 	return offset;
 put_err_out:
 	ntfs_attr_put_search_ctx(ctx);
-	return -1;
+	return err;
 }
 
 /*
-- 
2.53.0



