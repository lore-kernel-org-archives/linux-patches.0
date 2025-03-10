Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFBF1C4A24;
	Mon, 10 Mar 2025 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629482; cv=none; b=gSvFhJDQHA9AdtnveGRmOuYgsojktU9nfT7lxm4eoxchdmecckkQiDiQrUIzy+UgXWEAfMLhvl30uguGSj8Ljs9qk3jZVxe4mFv3cAiz/u4mVVTP6C9oNh/TezkBFg4FtUrewcdMEzCr2F0MUyaxEcdGMAlHRp0ZmlSoGKKIMQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629482; c=relaxed/simple;
	bh=9LN5j53TTzmbRY5df1XL1Q2PoJxTA7xRJ9cdcCjf02Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVpghtEvqNzlaDNyJKJ2MMwD/rt9vCfvywMTfJ8HCD/GuKLilBfnshYmn+90UagyewwYg85MjdsRFa+Y2OqmsZi9dMakqfLncYimTmxeuFd2//jge8wAiRiXFU7ccL2AyiptwlOwxU0HnO55BE7x5kXMhw0b7iXpDbPjZ9Db8P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/K3QeV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/K3QeV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6247FC4CEE5;
	Mon, 10 Mar 2025 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629481;
	bh=9LN5j53TTzmbRY5df1XL1Q2PoJxTA7xRJ9cdcCjf02Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/K3QeV5l7qYPUm/LCbs/g9MGNvGaYSPFycYWh3ZQVtC4Un3X9ft3MXzLd+vwoRIG
	 tjWQcYA4+4i1+cIYAg2Kdr1kjVGEnqY/tzUBrnp7Y0Rn0dULv0T2m98rs1vxuQLhVu
	 m5fqdh5yNoG/Nb0NXB+E/2gE2ZBhWVfNvcyvigHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 309/620] media: ccs: Fix CCS static data parsing for large block sizes
Date: Mon, 10 Mar 2025 18:02:35 +0100
Message-ID: <20250310170557.815435698@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 82b696750f0b60e7513082a10ad42786854f59f8 upstream.

The length field of the CCS static data blocks was mishandled, leading to
wrong interpretation of the length header for blocks that are 16 kiB in
size. Such large blocks are very, very rare and so this wasn't found
earlier.

As the length is used as part of input validation, the issue has no
security implications.

Fixes: a6b396f410b1 ("media: ccs: Add CCS static data parser library")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ccs/ccs-data.c
+++ b/drivers/media/i2c/ccs/ccs-data.c
@@ -98,7 +98,7 @@ ccs_data_parse_length_specifier(const st
 		plen = ((size_t)
 			(__len3->length[0] &
 			 ((1 << CCS_DATA_LENGTH_SPECIFIER_SIZE_SHIFT) - 1))
-			<< 16) + (__len3->length[0] << 8) + __len3->length[1];
+			<< 16) + (__len3->length[1] << 8) + __len3->length[2];
 		break;
 	}
 	default:


