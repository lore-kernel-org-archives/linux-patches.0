Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C227FD7F;
	Wed, 23 Apr 2025 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422252; cv=none; b=BMEKCnbZ1jHceLc6jaH2HDgNovx03mJE89be6uf6GJn1ncxxZOU5h5ofN2tuQjBGu4/p2K3BM3tPjI6G9MK+JvcSAHYqbKAfadCIJ1nVtDwoFVNGSURq2BCHXP8L6g5AEiA21YNwHqZ9pJvuLU4wvVQYlDtvLJJfgpZp02zjp8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422252; c=relaxed/simple;
	bh=vCrNV5Ep0Be2fP9czEi4ya+G254XOqQWlvqvNwnHODQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNJP4tVHeLWdEZLFCxgqrc17a4gGT4L/8JIZgbppiAb3YLrzhENjOkdXDpk1OiRbqAhMCr0prwKIxNLugAxqeZbjd6wBJ/vl8obTAlKgW1Ghr7r1YBHxb8aCFcJAR+dTDWBbSkrq2vBKpsDTg5S+rt8mI8Bl5Q9eANiZHJ44Alw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVmK48R7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVmK48R7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32471C4CEE2;
	Wed, 23 Apr 2025 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422251;
	bh=vCrNV5Ep0Be2fP9czEi4ya+G254XOqQWlvqvNwnHODQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVmK48R7rnSO/dhqqjB22cF8xwz1JrNLNvAIwoUk2ZejcJMBFlGkIdYR4/JsAsCVZ
	 LXsioArCsQbcOXexn+CXhgYhEYz5IUtNdO3ydxFsjDlHvAgdhsF59c1xQHHCc6YcNa
	 I2kGcHu2E9rzkq7FUEokDl6GElvirqLxPpLRkU34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Milan Broz <gmazyland@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sasha Levin <sashal@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.1 264/291] mm: Fix is_zero_page() usage in try_grab_page()
Date: Wed, 23 Apr 2025 16:44:13 +0200
Message-ID: <20250423142635.211780540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@redhat.com>

The backport of upstream commit c8070b787519 ("mm: Don't pin ZERO_PAGE
in pin_user_pages()") into v6.1.130 noted below in Fixes does not
account for commit 0f0892356fa1 ("mm: allow multiple error returns in
try_grab_page()"), which changed the return value of try_grab_page()
from bool to int.  Therefore returning 0, success in the upstream
version, becomes an error here.  Fix the return value.

Fixes: 476c1dfefab8 ("mm: Don't pin ZERO_PAGE in pin_user_pages()")
Link: https://lore.kernel.org/all/Z_6uhLQjJ7SSzI13@eldamar.lan
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Reported-by: Milan Broz <gmazyland@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -232,7 +232,7 @@ bool __must_check try_grab_page(struct p
 		 * and it is used in a *lot* of places.
 		 */
 		if (is_zero_page(page))
-			return 0;
+			return true;
 
 		/*
 		 * Similar to try_grab_folio(): be sure to *also*


