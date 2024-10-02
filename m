Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949B29CE7;
	Wed,  2 Oct 2024 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875853; cv=none; b=dZ9nzCFndsamNh7RMb3BzHYU+4wZZjAeMDdLMzzv+gybG5Z/HcSBhDHvgLeWurasYM/bKjKttzmq+dp3fsyPLCQo1yStw64xtrpV6z5wwCLH3zMMKatl1lQrGdOTIwqb0PASCiXnTeD7WeAmoaCcxv+cHZAgQovJtL9D5xHGWiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875853; c=relaxed/simple;
	bh=vbhOrktH7oqk1Nv+9Me969dioR8tRjHt+qVGCdGMZZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNDcVa+Mkqu1AOy29ia0U93U0eX62p4jYpplflT1EZu2a8SScd3myiV1Etoc/KOI/1Cy4kj77d5N+7MPPDcgIe7EQwNgikbWrBgx18ZiKS8L4LoVaVHz6p338jRe3OegbkqM2a/zE67FGv8HVgsaUwnjRcpPjwxc49Eo0St47Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdZXqejw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdZXqejw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32C1C4CEC5;
	Wed,  2 Oct 2024 13:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875853;
	bh=vbhOrktH7oqk1Nv+9Me969dioR8tRjHt+qVGCdGMZZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdZXqejwk5Q4pB9d1uS5vhOnSqjNKPkPbQlm984NkbqJpoFfLDVYg/4YC+m3g/75A
	 lHz+WFK6stjMVeoMpOeWbOrEwT5ul8xGQ1rfQeGufFQ4sC1rtbaySk9zw65Mg/hu+q
	 Jb892cQ57TSjyvrCO7FPtDs1ysu1fST+1StU76XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Joshua Dickens <joshua.dickens@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 243/695] HID: wacom: Support sequence numbers smaller than 16-bit
Date: Wed,  2 Oct 2024 14:54:01 +0200
Message-ID: <20241002125832.152772153@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

[ Upstream commit 359673ea3a203611b4f6d0f28922a4b9d2cfbcc8 ]

The current dropped packet reporting assumes that all sequence numbers
are 16 bits in length. This results in misleading "Dropped" messages if
the hardware uses fewer bits. For example, if a tablet uses only 8 bits
to store its sequence number, once it rolls over from 255 -> 0, the
driver will still be expecting a packet "256". This patch adjusts the
logic to reset the next expected packet to logical_minimum whenever
it overflows beyond logical_maximum.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
Fixes: 6d09085b38e5 ("HID: wacom: Adding Support for new usages")
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 2541fa2e0fa3b..0c8713fe0d179 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2446,9 +2446,14 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
 		wacom_wac->hid_data.barrelswitch3 = value;
 		return;
 	case WACOM_HID_WD_SEQUENCENUMBER:
-		if (wacom_wac->hid_data.sequence_number != value)
-			hid_warn(hdev, "Dropped %hu packets", (unsigned short)(value - wacom_wac->hid_data.sequence_number));
+		if (wacom_wac->hid_data.sequence_number != value) {
+			int sequence_size = field->logical_maximum - field->logical_minimum + 1;
+			int drop_count = (value - wacom_wac->hid_data.sequence_number) % sequence_size;
+			hid_warn(hdev, "Dropped %d packets", drop_count);
+		}
 		wacom_wac->hid_data.sequence_number = value + 1;
+		if (wacom_wac->hid_data.sequence_number > field->logical_maximum)
+			wacom_wac->hid_data.sequence_number = field->logical_minimum;
 		return;
 	}
 
-- 
2.43.0



