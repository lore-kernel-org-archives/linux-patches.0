Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1C91D12EA;
	Tue,  8 Oct 2024 12:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390004; cv=none; b=OhVBmShJ9tPO63Awqh6CHQ/YaxtCxjdw5Waf+GLb8K0rADd1EuGYSWckJ/D1y4D6AZbGWAKv4QsBS6fZJVF/C1vzdwjIOqqu/2NDHYYrqxxNGevYyPCJ0W8mLuNetZBv7niQqBa0Q1STh+c+1Qc4epw0mwJywEiLH8PGW/ZE+fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390004; c=relaxed/simple;
	bh=M7J3qIkgPL4C2a+C2gOGzE6hNkzHKxf3v7bHPm55cMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9oR4Qn3xmjJ3QQmsJzzHZHbM2w5lpUSRsuVK9Rb8EOkUjIN96U2UyOrTRdYX/sQDb31lTbgcso3R7PlVTamL2EZlKfIJzphBF4YFSejxPyW1G1OfYnloxQYsQrZnT/JqOWv3Zv6tKkreaEoRriSRTN/musxISU43T5D4ngNFic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbU2Ywuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbU2Ywuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4737C4CECD;
	Tue,  8 Oct 2024 12:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390004;
	bh=M7J3qIkgPL4C2a+C2gOGzE6hNkzHKxf3v7bHPm55cMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbU2YwuolfFHHtZhiXVImqYQnjEyzXHD0RLx3pQqhFsmZaKdLByx8RNm9IAF+vZrQ
	 7eX7AjTZ0vu6esiNgO/Ih//i26qc0+SZpbk0VwYv+F5aOrk/anlsIKdEhInTq6mohs
	 ZP9NWjvB+yx/S3jiAOiL/T5EXffcd3DBMJWrPe4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 120/482] ACPICA: iasl: handle empty connection_node
Date: Tue,  8 Oct 2024 14:03:03 +0200
Message-ID: <20241008115653.029246643@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

[ Upstream commit a0a2459b79414584af6c46dd8c6f866d8f1aa421 ]

ACPICA commit 6c551e2c9487067d4b085333e7fe97e965a11625

Link: https://github.com/acpica/acpica/commit/6c551e2c
Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exprep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index 08196fa17080e..82b1fa2d201fe 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -437,6 +437,9 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
 
 		if (info->connection_node) {
 			second_desc = info->connection_node->object;
+			if (second_desc == NULL) {
+				break;
+			}
 			if (!(second_desc->common.flags & AOPOBJ_DATA_VALID)) {
 				status =
 				    acpi_ds_get_buffer_arguments(second_desc);
-- 
2.43.0



