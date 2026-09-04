Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9734F2F9DA1;
	Fri,  4 Sep 2026 05:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501009; cv=none; b=ezduFcf2R2r5RwK1b3bDVkwLV8hjYeKFnrAtPxc+D7FW8XHXvhpPg/ts7PQE3K3hr2NeyAAIIQFJQJBmNFILXhcfGWF8fJ5oE3EMrCjT51z2mCAho7pJJVLEp4XO3F9NhiJWtlCcPRLD0BWEwMY8tl0yiy3GmXj56q/eQwnZcvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501009; c=relaxed/simple;
	bh=Tl+Va6EkSH+Pynn7ZdGeUK65o8sCqNlkezPx6bbQy9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzauZDcsfRmPqv6jpbzRH04SYgPa1+jKSNQkNm9pwp2RCTKhB91FVXLPmtwhYWuhvsj04jo6IJ7MocypZrJPNTZLP/tn/QQLO50uiluAiY4Qjn7EJ6oyt+3UXoC3UulVAiHb1r0J9Ll3K97Jkxjd/Sz7+hHcJ7lY3qfdz7jhsNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IggnoB3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IggnoB3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D4B1F00A3D;
	Fri,  4 Sep 2026 05:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501008;
	bh=P5Q/RMwTngzqnoZKe9PJ3/E42wYeyRZP+Abtm3+dB+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IggnoB3mxZbHUEBgdnbqd4QVWa/lKfIbTunOFlCUtG40HXRe1GoDsLV81XL32PFKE
	 UIlFddYnT0XqjbGHbwVoOoLQTNzQMk7BmIsgrlHzwmdZU6kxwYGEI4zkyIE2BvgxoO
	 dsd6dF56g54/6rLMlaBWmyGfk3qE0FHcIlbGr+/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 215/552] ACPI: APEI: GHES: fix ARM section length accounting after header
Date: Fri,  4 Sep 2026 06:56:12 +0200
Message-ID: <20260904045754.329174082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: TanZheng <tanzheng@kylinos.cn>

commit 903308ea40adf0577d82eab69882faf8836326ce upstream.

In ghes_handle_arm_hw_error(), after skipping the cper_sec_proc_arm
header with (err + 1), the remaining length was reduced by sizeof(err)
(pointer size) instead of sizeof(*err) (structure size).

That overestimates the bytes left for cper_arm_err_info records and can
let the parser read past the CPER section when err_info_num is large
enough relative to error_data_length.

Use sizeof(*err) so the length accounting matches the pointer advance
and the earlier sizeof(*err) size check.

Fixes: 87880af2d24e ("APEI/GHES: ARM processor Error: don't go past allocated memory")
Cc: stable@vger.kernel.org
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://patch.msgid.link/20260806010944.32384-1-kensanya@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/ghes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -581,7 +581,7 @@ static bool ghes_handle_arm_hw_error(str
 		return false;
 
 	p = (char *)(err + 1);
-	length -= sizeof(err);
+	length -= sizeof(*err);
 
 	for (i = 0; i < err->err_info_num; i++) {
 		struct cper_arm_err_info *err_info;


