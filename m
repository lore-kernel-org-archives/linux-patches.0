Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9855ABE46;
	Tue,  8 Jul 2025 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993693; cv=none; b=NcphYsqQV/h1dzvu5mb5oeNkNmK7MhDG/N9i5JA3pcLs7oGMeuscFIQ3+VQEbIgtFNQwS+3RhSjQmsRiPH6Iz70//+uUIIw+gFNDS+fH7JK0vLNFVsxi8tEWpu/OlKat9gsHOvjN1XtmXwvG3eOZGHbKRVHhnOuX5ydxUZaGlSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993693; c=relaxed/simple;
	bh=MZq8L9L4U37vkJUaWCpo2bJdXTQBnEf0iy+XvrIfJYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdSzbf1tgADzqjgy7WU8q8D/xqtpT15BjyEELVE1ZDEtr87LAghgxwfOlg0NsdrAPhp+n3yAQ6kGIrDTg+eeC/QJRvlH/7VR4zFfZp53lkV1jn9lRC2HIiJp05wz1vLvV3+z8aMx4OSo9HU6fMUcbT08pEhjWH8yQU/udDHJeQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joPlWHeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joPlWHeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A37C4CEED;
	Tue,  8 Jul 2025 16:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993693;
	bh=MZq8L9L4U37vkJUaWCpo2bJdXTQBnEf0iy+XvrIfJYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joPlWHeF1kKMU9sITmMkJluXVJTRHr0S8zGgpw2olK/eygY5v30ldEksgVUBgb/uJ
	 XZkef26m36/bTgjDDdFrifPLsnYoeveVVY7qACbwcTBzYcKqj7/9YrlI49W54d5fff
	 ZPVACoAdSWTY/4RLfKri5EstXhA+IMLEwONu1K60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 161/178] i2c/designware: Fix an initialization issue
Date: Tue,  8 Jul 2025 18:23:18 +0200
Message-ID: <20250708162240.689291870@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

commit 3d30048958e0d43425f6d4e76565e6249fa71050 upstream.

The i2c_dw_xfer_init() function requires msgs and msg_write_idx from the
dev context to be initialized.

amd_i2c_dw_xfer_quirk() inits msgs and msgs_num, but not msg_write_idx.

This could allow an out of bounds access (of msgs).

Initialize msg_write_idx before calling i2c_dw_xfer_init().

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 17631e8ca2d3 ("i2c: designware: Add driver support for AMD NAVI GPU")
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250627143511.489570-1-michael.j.ruhl@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-master.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -363,6 +363,7 @@ static int amd_i2c_dw_xfer_quirk(struct
 
 	dev->msgs = msgs;
 	dev->msgs_num = num_msgs;
+	dev->msg_write_idx = 0;
 	i2c_dw_xfer_init(dev);
 
 	/* Initiate messages read/write transaction */


