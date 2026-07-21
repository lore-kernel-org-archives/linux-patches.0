Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F471439903;
	Tue, 21 Jul 2026 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671452; cv=none; b=QCgA+Op3v8u1bdOLXKgdOUuF6XrQnq6nExrJInZX2urWwRkPVfZz/WyxoWRI0nH1GWTs3mLVKXZ4BcH1bZZPrziQWdgY1sN2WJi8qG7k//4OYDXERywTCNKpD01N5T7qz6+lgH8LNaqjmYZqoJ2sG0Kw/yDkfxvcqr7EO/vAAlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671452; c=relaxed/simple;
	bh=5LPFY+NQ5PgIugHhxvIh0Iv4WBLszFA1wsC9Htl6vL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvGYtOa7NPv4NWRn7s7HP3Z53B7fKC9G4lz2aWtTf+q5FPxhVhgka0yAXTF7d0Nvc0OhHJTfy9v3jY5y4OAmO1jYYdec692Juv2UmjYjw/RLtMVTuMNaXdVHdQSdOnr/J4jT/TOW797MhXMW17w4HzBC2KjZUi4rUqDgHjF1TWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8CF3yFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8CF3yFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45671F000E9;
	Tue, 21 Jul 2026 22:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671451;
	bh=t72BsY/k6HIWDeZw5A3EuftK86ppNKhsCIvdmrAa2CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8CF3yFCDZmy4GFYNgx/SZfvLEHoT0fehfqWaP5MCTwHQvA+M96E9wr/e6Etp3Y/a
	 9OMstfgTU1KmSrM0ZT9MTxdoNlV4oIoV52inYaPx32b+ts8gQwqfHBOHGkjwQxovO2
	 n00tQDkq+rmS2Z+xxAlj/04XiygTfDRyJ55BBqtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/843] firmware: arm_scmi: Fix OOB in scmi_power_name_get()
Date: Tue, 21 Jul 2026 17:18:05 +0200
Message-ID: <20260721152411.646385261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f9ef3f66f4b18078e464b7606f9497e4dbeb9905 ]

scmi_power_name_get() does not validate the domain number passed by the
external caller, which may lead to an out-of-bounds access.

Fix this by returning "unknown" for invalid domains, like
scmi_reset_name_get() does.

Fixes: 76a6550990e296a7 ("firmware: arm_scmi: add initial support for power protocol")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://patch.msgid.link/75caae28bdffb55199a0bc6cac5df112a966c608.1778838987.git.geert+renesas@glider.be
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/power.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/power.c b/drivers/firmware/arm_scmi/power.c
index ad2ab080f3443c..0b52b1a4e864b5 100644
--- a/drivers/firmware/arm_scmi/power.c
+++ b/drivers/firmware/arm_scmi/power.c
@@ -178,8 +178,12 @@ static char *scmi_power_name_get(const struct scmi_protocol_handle *ph,
 				 u32 domain)
 {
 	struct scmi_power_info *pi = ph->get_priv(ph);
-	struct power_dom_info *dom = pi->dom_info + domain;
+	struct power_dom_info *dom;
 
+	if (domain >= pi->num_domains)
+		return "unknown";
+
+	dom = pi->dom_info + domain;
 	return dom->name;
 }
 
-- 
2.53.0



