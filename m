Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A341FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F65C433EF;
	Fri,  3 Feb 2023 10:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419272;
	bh=5AdfehtpVwsE7IDrQweR1bmvBoQh5kSTNaYcnlJPXBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVBT7LLlOebiKRiOZn6F79hyzEKwNJbHjNbTiO7Bo64cMGqXIPntFoaarf3FHsyEX
	 3+MLqetCx6LHDGCOrgCYjn+05gtkVuAAMf2IOmMoyvmtw4x4qzJfQdEcI+AQH9WhUe
	 nKp++1emo3S18Pz1p4AIzd6SauLI+wrS8vGjfZHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/62] HID: check empty report_list in hid_validate_values()
Date: Fri,  3 Feb 2023 11:12:10 +0100
Message-Id: <20230203101013.622660138@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit b12fece4c64857e5fab4290bf01b2e0317a88456 ]

Add a check for empty report_list in hid_validate_values().
The missing check causes a type confusion when issuing a list_entry()
on an empty report_list.
The problem is caused by the assumption that the device must
have valid report_list. While this will be true for all normal HID
devices, a suitably malicious device can violate the assumption.

Fixes: 1b15d2e5b807 ("HID: core: fix validation of report id 0")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a3debe38d2c7..ab78c1e6f37d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -984,8 +984,8 @@ struct hid_report *hid_validate_values(struct hid_device *hid,
 		 * Validating on id 0 means we should examine the first
 		 * report in the list.
 		 */
-		report = list_entry(
-				hid->report_enum[type].report_list.next,
+		report = list_first_entry_or_null(
+				&hid->report_enum[type].report_list,
 				struct hid_report, list);
 	} else {
 		report = hid->report_enum[type].report_id_hash[id];
-- 
2.39.0



