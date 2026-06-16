Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF18478E53;
	Tue, 16 Jun 2026 16:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629154; cv=none; b=Tdq62bNor/SLniT7CQmVqgEn3eHacVUqcTpEbvWkKYHfbarjjoq9BeVdX5S+34ofgj3kk+dt1BDaz73iOwh454cG8lFd3k2jNy3KRTQ7S1WxPcSTHkQ4PzE+NO/yz/jdrEUm2rraL0RQ3aq57Vs6Xnrt5zmjfz63jEEWDnUuGSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629154; c=relaxed/simple;
	bh=ZYxQPnCciAmjL1xuYY9YZ+vuNVB8FYaZQ8PIfMHOlX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AM/jI9/vC8fhRmu62VT6QLYi3lStSU+R0V+I1YQpCR3Cu6S6T9xgaEU6/Jo9QkLiEHQEa4xwwIig7k4DZDaE3wuUMty6wcGUnL8x1o2/bSmB9wqSw+RYCw8bK5BxDJSPKeIgkWCV5PUBHIaJc62BRy8bM8no0SDH/oBWsmYTAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4sln9qN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4sln9qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3083C1F000E9;
	Tue, 16 Jun 2026 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629153;
	bh=reNH4HoZ7gsGm67UmJWyILLFKAVo0ijkKCCsGMT8jgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4sln9qNpqIcKK4ScGfMBlxjvskWnpvmLk/+5byIZZAbmEzDMiv/RghuVcVz4d4Zo
	 9GK+cU1poYkIWRycrDyMnLvs1cqn48jJCiboSBas3VuI2zRwoLqzDZcsSpzOsIXSZx
	 YN+2C7RZzlMO3RbJDfvyyCEk0ufgks898RKCmrYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zhang Cen <rollkingzzc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/452] Bluetooth: MGMT: validate advertising TLV before type checks
Date: Tue, 16 Jun 2026 20:27:39 +0530
Message-ID: <20260616145129.901149711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit de23fb62259aa01d294f77238ae3b835eb674413 ]

tlv_data_is_valid() reads each advertising data field length from
data[i], then inspects data[i + 1] for managed EIR types before
checking that the current field still fits inside the supplied buffer.

A malformed field whose length byte is the last byte of the buffer can
therefore make the parser read one byte past the advertising data.

KASAN reported the following when a malformed MGMT_OP_ADD_ADVERTISING
request reached that path:

  BUG: KASAN: vmalloc-out-of-bounds in tlv_data_is_valid()
  Read of size 1
  Call trace:
    tlv_data_is_valid()
    add_advertising()
    hci_mgmt_cmd()
    hci_sock_sendmsg()

Move the existing element-length check before any type-octet inspection
so each non-empty element is proven to contain its type byte before the
parser looks at data[i + 1].

Fixes: 2bb36870e8cb ("Bluetooth: Unify advertising instance flags check")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 4271fba3245ce1..7b86e287b12d64 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8667,6 +8667,12 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 		if (!cur_len)
 			continue;
 
+		/* If the current field length would exceed the total data
+		 * length, then it's invalid.
+		 */
+		if (i + cur_len >= len)
+			return false;
+
 		if (data[i + 1] == EIR_FLAGS &&
 		    (!is_adv_data || flags_managed(adv_flags)))
 			return false;
@@ -8683,12 +8689,6 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 		if (data[i + 1] == EIR_APPEARANCE &&
 		    appearance_managed(adv_flags))
 			return false;
-
-		/* If the current field length would exceed the total data
-		 * length, then it's invalid.
-		 */
-		if (i + cur_len >= len)
-			return false;
 	}
 
 	return true;
-- 
2.53.0



