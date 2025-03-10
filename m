Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4139E231CB0;
	Mon, 10 Mar 2025 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626862; cv=none; b=Ss1dTJ9rCHYkM+SmFppIk3s7pOyVd8gyTnjPExSXeFeD7Qn/1sEH6Y+Qnifr20yYl8iNM71lokh2pLdfRIOQDx7MVOrRJbbd1UGh1h4bl9Q9IPpSGuRm0YBZ40gfOUbFlsPOVXhxnUp3ldPsi7XtnH9L9z9zRAiqrliCTpx9PW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626862; c=relaxed/simple;
	bh=7s+SjlOmhpDtZyJ3yPLEThT5oCWKPfmxyX6YkABccGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFcMUHw3Cbzgkrpy4T5UpU0BOpIb4EJ/Pmi7hXU1opGJrTGIspfKEaw507fLuHjnrk9TU99E9Fml/+uCKqL06KOLcy4aR+Evp3/1Ag9mU1IKZ2G0JeLFtd5oP7bxzRKS1uLXSU5Hh+3ANo0z1G4DHRqKa0TDlWAD0jp6OQqUo+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIId12NB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIId12NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD71C4CEE5;
	Mon, 10 Mar 2025 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626862;
	bh=7s+SjlOmhpDtZyJ3yPLEThT5oCWKPfmxyX6YkABccGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIId12NBqOqDHVg8f4uQ0lQ9WIEaCKO4f1ZW0LyBmz0Uq3KTsqOlnAIKuzOzjyc6H
	 OT/bUtLZjTlJBRVhkSPlvMTOT9HQVyo4Vj5QUWNGvQGGXUm6jbM8yW01XlhsMvJKae
	 /PqHfYQNBvcCtzJrYvBmO/Mr7UhIPL8Ij7oOZtjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 137/207] x86/sgx: Fix size overflows in sgx_encl_create()
Date: Mon, 10 Mar 2025 18:05:30 +0100
Message-ID: <20250310170453.242445525@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit 0d3e0dfd68fb9e6b0ec865be9f3377cc3ff55733 ]

The total size calculated for EPC can overflow u64 given the added up page
for SECS.  Further, the total size calculated for shmem can overflow even
when the EPC size stays within limits of u64, given that it adds the extra
space for 128 byte PCMD structures (one for each page).

Address this by pre-evaluating the micro-architectural requirement of
SGX: the address space size must be power of two. This is eventually
checked up by ECREATE but the pre-check has the additional benefit of
making sure that there is some space for additional data.

Fixes: 888d24911787 ("x86/sgx: Add SGX_IOC_ENCLAVE_CREATE")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20250305050006.43896-1-jarkko@kernel.org

Closes: https://lore.kernel.org/linux-sgx/c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b65ab214bdf57..776a20172867e 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -64,6 +64,13 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct file *backing;
 	long ret;
 
+	/*
+	 * ECREATE would detect this too, but checking here also ensures
+	 * that the 'encl_size' calculations below can never overflow.
+	 */
+	if (!is_power_of_2(secs->size))
+		return -EINVAL;
+
 	va_page = sgx_encl_grow(encl, true);
 	if (IS_ERR(va_page))
 		return PTR_ERR(va_page);
-- 
2.39.5



