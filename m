Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C812F50C287;
	Wed, 30 Sep 2026 18:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792393; cv=none; b=eqfPhtkOclCVV/lFjBVFqMJW82ymtp94x0LKUNiA7NSjIQff11r3Qvvm7IXBaUZ/yKtpCfBpjEOYZV3/4QlgweF9OYWyUfaLpCAiO1gWgRSHMNFYCdXLvS7jlJgNzkYP6fM9vK2jWiRYQw2EfXSVtkdAis5bbJTa/DXA0ItBqeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792393; c=relaxed/simple;
	bh=ptQAyGgvvPkOSrZ56oW1L9KWbIZ2M/IQh/SRxXvg6lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB+T3CmqHZuwH4FMN2EGToE0P0vLTuD9EzfEeLIN7piSpQCuPsjCscHtyAmWngEcKfahNHYYRzR2etK5Zgapiu6kMVxClyoVvtQRQSb2zh7CiGbqxB+ziqWk2ATbkSf89eLdgvIJ9GigBJdk5ARBW04IS00aHklbLCINykxtzpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuKb0Qgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuKb0Qgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F94A1F000FF;
	Wed, 30 Sep 2026 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792392;
	bh=tkYeO45//uDl/e+llmz5ViVEuO8KeSPVtvCkDxnG4gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FuKb0Qgtkx9AtnxQCoImky764DEioBmrz7noRGfrJg3hQCS404VH3EBxKbqORLX4h
	 /J27Xdp0BmSRMCnYMqtCG4qOf1MqnvTcI7uYapp71s5wzCm4VuYgXxZTNy1/c/Y59C
	 51MuuOEXgva/c80YF5mWElmCmbQblSgk9kefhAII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 638/752] s390/debug: Fix NULL pointer dereference in debug_info_copy()
Date: Wed, 30 Sep 2026 17:28:28 +0200
Message-ID: <20260930152412.072959128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit 012bfcd5a51082d5a65f096dfb9ca652b5267965 ]

When debug_register_static() fails, it clears areas, active_pages and
active_entries but leaves the area bounds unchanged. Copying such an
area, either by opening its view file or via debug_dump(), makes
debug_info_copy() dereference the NULL pointers.

Skip the copy loop when the source has no areas.

Closes: https://lore.kernel.org/r/20260903132123.12F271F00A3F@smtp.kernel.org
Fixes: d72541f94512 ("s390/debug: add early tracing support")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 6b0fe0c0d94c4..3bdb177685d46 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -345,7 +345,8 @@ static debug_info_t *debug_info_copy(debug_info_t *in, int mode)
 		debug_info_free(rc);
 	} while (1);
 
-	if (mode == NO_AREAS)
+	/* debug_register_static() failure leaves areas NULL, bounds intact */
+	if (mode == NO_AREAS || !in->areas)
 		goto out;
 
 	for (i = 0; i < in->nr_areas; i++) {
-- 
2.53.0



