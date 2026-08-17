Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE743C7C1;
	Mon, 17 Aug 2026 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978741; cv=none; b=ZZEUyojR19nX5DCHWIqi4Uk18eBEAOQXJoAKIrU/sUGC0jHq0zWDCDSt29j13z0Ka4RbLdKu0ujriJyiIPy3UYufBrsIW8Rlc83ITlkq8+hS6lgvTLI4nrsOW9h1W4KvdfK9zP51tmsTvDBccX8dDSVV9zGJVmXA/upYxsqnsfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978741; c=relaxed/simple;
	bh=FlyD5G27Ap/0JnSvqTJ1YIzi1tWawHpO4I9qg0/WMi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwwJHuGLlQUz36hNX1Txez/d6n4dqd+fYE0F+LHCRFlrK3jzKcZuW4ENUEUyIRTr+yRl6SrXsuLXC8j72uT7XD33YmjLLXjRVlURLcDQ6fKBgEcLvTukRIcMmuAok+0PkXmDmJ95DAjaoZK/F7YjGnMhc995WEDqP4C1Xy/mV5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9bkj4nT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9bkj4nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888591F000E9;
	Mon, 17 Aug 2026 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978740;
	bh=Uqv9gn+C6UMrip8ravgmFw4uF+YSa07bT8KI3OprCss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9bkj4nTFWZS0Xomo+HtDqBU9QYkjxpS2xiuPFf7SdpWnmSwKfJ8Xc9BQLHtlnl23
	 IqiEmrx5xZ9qhSh93XwL+ZBx0YYNHFhabIbjDl2Spy4lCaZzazd9IUXvlrTxdOLJXc
	 nD0mS3urvEYozHHzVb5TenNWJD6042JEFQaFyqck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 141/156] ptp: ocp: Fix board ID over-read
Date: Mon, 17 Aug 2026 15:34:35 +0200
Message-ID: <20260817132540.225711100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Ahmad Byagowi <ahmadexp@gmail.com>

commit 6b69f2ef10cdb018c0b127a7cab88e590bbddba4 upstream.

The EEPROM board ID is a fixed 13-byte field and is not guaranteed to
contain a NUL terminator. Passing it directly to
devlink_info_version_fixed_put() treats it as a C string and may read
beyond the field.

Format at most OCP_BOARD_ID_LEN bytes into the existing local buffer
before reporting the ID. Use a precision limit because the snprintf()
output size alone does not bound the source string scan.

Fixes: 0cfcdd1ebcfe ("ptp: ocp: add nvmem interface for accessing eeprom")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Byagowi <ahmadexp@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260804210751.48248-1-ahmadexp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_ocp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1671,9 +1671,11 @@ ptp_ocp_devlink_info_get(struct devlink
 	if (err)
 		return err;
 
+	snprintf(buf, sizeof(buf), "%.*s", OCP_BOARD_ID_LEN,
+		 (const char *)bp->board_id);
 	err = devlink_info_version_fixed_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
-			bp->board_id);
+			buf);
 	if (err)
 		return err;
 


