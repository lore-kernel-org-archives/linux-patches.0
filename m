Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F0A1F543F;
	Tue, 21 Jan 2025 18:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483153; cv=none; b=JSCuxQI58iEYZ/Elnfff6XPo3rLDguczg2pIwX4iai/nlBgF/oXjRkB2ISaZpKM9jYWh8YbpW+9HbBh1YRD7CZrebX6yTopNv74A48Jc2HpzNQtYPoVnC1Y+Grxnt2gA5MIK9/1pk4xVv5C51EoJjKFWS/tjx1yG0US/jn+bhIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483153; c=relaxed/simple;
	bh=bEg3pRokxI7CAKbNeQD6+VNNOYoCOGhEa+mN6EZbtqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCmpleNUj1FgzdsMpTnT9Piyt7FRwk780Tw0O6AzxNki8TlIWpdYxAtlq7un8HTwMu+Au55LYMtJ7kUipzdzvYg72snvEkBD+/M8VUMDQjDG1H07solCvYrxLs4E5gRPTYIIKpsFMYOzI7OD2DOAFUqjqAt2K0i9/DfN5PG4p04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbO2KZ/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbO2KZ/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D31C4CEDF;
	Tue, 21 Jan 2025 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483153;
	bh=bEg3pRokxI7CAKbNeQD6+VNNOYoCOGhEa+mN6EZbtqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbO2KZ/LxK/KNSwPNdwGaPXdceqafdbBM19yoROKBfSXv6T7tykqb9mCSIOYXbC24
	 d+3miNpMr24jqFckzrC48lxth4P2ZLuwHQ2FGuCsIXHyKs+69IG8+U/wTbnuzo9ad0
	 g+JAOf6BsrQLWJNHzdXbk431RVB/HRu368UAstho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nelissen <marco.nelissen@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 109/127] filemap: avoid truncating 64-bit offset to 32 bits
Date: Tue, 21 Jan 2025 18:53:01 +0100
Message-ID: <20250121174533.854777714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2818,7 +2818,7 @@ static inline loff_t page_seek_hole_data
 	do {
 		if (ops->is_partially_uptodate(page, offset, bsz) == seek_data)
 			break;
-		start = (start + bsz) & ~(bsz - 1);
+		start = (start + bsz) & ~((u64)bsz - 1);
 		offset += bsz;
 	} while (offset < thp_size(page));
 unlock:


