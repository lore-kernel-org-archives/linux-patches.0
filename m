Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A8F1F4275;
	Tue, 21 Jan 2025 18:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482686; cv=none; b=pz1Z+FsngDoRbIyzUPCGAyRC7VUsq9ZHZZ6RLUh82YL9fq/+JWJ882sSjGsu2YjTYIl2mjmu+mtQOy9aoQuWg9sLXLHIAMoHyaXewl1tFBuQpTYI54RhgM2g+s4DbdBB2nOtXThGEDv76CC4JxdJuNpqjoe13M2hDE86oPSV+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482686; c=relaxed/simple;
	bh=h3wv/Ly/3ERIObe/ZBmeVv1dQbvGzxWXKBGYJAVQnpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ecci3557MtOBP3YDHvM+kZ87sr0pieUy58YFkN6ynkqDKaVnBZrZw6iwznjEt5V7tgSZZoMFYOelUJfPwW4vM0COGQJMWtUaTBcpWGH+0o+1reVvvo3+ybEYY+lDNb9zOylWlP7zoSJ/L361vD5gyYq4z7ryK4BV17OD9t8xAP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvGxuI2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvGxuI2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10F3C4CEDF;
	Tue, 21 Jan 2025 18:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482686;
	bh=h3wv/Ly/3ERIObe/ZBmeVv1dQbvGzxWXKBGYJAVQnpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvGxuI2ztVcMyAofHbFjUKuk+7S3o/Wa1undTKMgd52tyX/5dvbl8N82M9IzaSlwv
	 mLwqyLJ4jGuyK5rb+bl2AVj/R/8tcDm7WpmqREbgrHawdTO8paX+ru/o6lOKRyu4sx
	 9ML/dcRJxwsdrybm9Zc+WwP03uh6T6BeoA8n5BTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nelissen <marco.nelissen@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 39/64] filemap: avoid truncating 64-bit offset to 32 bits
Date: Tue, 21 Jan 2025 18:52:38 +0100
Message-ID: <20250121174523.041178965@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Nelissen <marco.nelissen@gmail.com>

commit f505e6c91e7a22d10316665a86d79f84d9f0ba76 upstream.

On 32-bit kernels, folio_seek_hole_data() was inadvertently truncating a
64-bit value to 32 bits, leading to a possible infinite loop when writing
to an xfs filesystem.

Link: https://lkml.kernel.org/r/20250102190540.1356838-1-marco.nelissen@gmail.com
Fixes: 54fa39ac2e00 ("iomap: use mapping_seek_hole_data")
Signed-off-by: Marco Nelissen <marco.nelissen@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2938,7 +2938,7 @@ static inline loff_t folio_seek_hole_dat
 		if (ops->is_partially_uptodate(folio, offset, bsz) ==
 							seek_data)
 			break;
-		start = (start + bsz) & ~(bsz - 1);
+		start = (start + bsz) & ~((u64)bsz - 1);
 		offset += bsz;
 	} while (offset < folio_size(folio));
 unlock:


