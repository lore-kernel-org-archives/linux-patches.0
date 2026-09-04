Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1262D24A05D;
	Fri,  4 Sep 2026 05:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498549; cv=none; b=TlWqBiWDnhBV9WoPsoAmV/asm4vbXkmRMtXrZzfnBIqu+9yBUUe7EhssCqT10NgvOdcc9kdcX15Y9vRzsvg0zFbjg9JvY45+3Q9ieWJCCsRDdGXgGvP19FQYY4ggSB10dyGwnsfOHxETSGyokW66rSBLsBuXIs6dOvNztOxrRhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498549; c=relaxed/simple;
	bh=T6x/VgOl/2SQ/+TrCdyn9MChkLbVNnmLp46LZPnMH/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZgFnOXt58g/QXGsXtUshFPB/ibQTqN60/14AatoTusSCXWwAp8KV+G/XIo4hO36AeQRdfGgrAHHF3QvyBjSE0quF3xKyr/EHb+O4q0rNvpt9D4OZIuzJauoc3RWGL61tYMMi+neOiHaN8BDwFZncJ0QiUtkzBkb7x+Gj+47LdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEUE9RhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEUE9RhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B18A1F00A3D;
	Fri,  4 Sep 2026 05:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498548;
	bh=CO5Gx6FYYlubP7RM6PbczjcKN9s6YiMNqE+dM5CaJe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEUE9RhJaa4fLFY7qr1RILmVk7r6UbLBVIP1NdV64JBEKENr2CG1krwIUQX7cPXT4
	 GOEWdh1y66MnL2VQdruSpbei/ufljsMTcCQpLNSYjB4VPefPkBg+S2xFJSSOIESQvu
	 dOYhi+1el9gKy3sdz7WBGB+LUVBIffcaheCJSj7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 7.2 102/713] staging: greybus: hid: fix SET_REPORT return value
Date: Fri,  4 Sep 2026 06:51:10 +0200
Message-ID: <20260904045806.122552627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit 6d45195a9626d8aaaaed212c55638829a9c624a3 upstream.

__gb_hid_output_raw_report() stores the result of gb_hid_set_report()
in ret and even adjusts it to account for the report ID byte, but then
always returns 0.

This hides Greybus transport errors from HID_REQ_SET_REPORT callers,
and makes hidraw report zero bytes written to user space on success,
although hid_hw_raw_request() is expected to return the number of
bytes transferred or a negative errno. The sibling GET_REPORT path,
__gb_hid_get_raw_report(), already follows this convention.

Return ret like the other HID transport drivers do.

Fixes: 96eab779e198 ("greybus: hid: add HID class driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Link: https://patch.msgid.link/20260704081613.434445-1-alvinhuang0603@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/greybus/hid.c
+++ b/drivers/staging/greybus/hid.c
@@ -256,7 +256,7 @@ static int __gb_hid_output_raw_report(st
 	if (report_id && ret >= 0)
 		ret++; /* add report_id to the number of transferred bytes */
 
-	return 0;
+	return ret;
 }
 
 static int gb_hid_raw_request(struct hid_device *hid, unsigned char reportnum,


