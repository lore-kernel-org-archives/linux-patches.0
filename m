Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBC91419BA;
	Wed, 19 Jun 2024 13:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803772; cv=none; b=ktuWxBbvydT9OhR43MIybES7e3+jEjvT098I99DxzzEdEpSmrFQyXfvwhV4uN4wQhmknejoqr62nogojwwxofgy39N5OWA6+hyGAmfYfmyACPRIB3KxArJTmMl+IpofMGM7JxuvOKJ68WuwVe+g4gEvjIKy1usH4NAYe2QGVB9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803772; c=relaxed/simple;
	bh=fp5dhBdtQielZMFVxhekSx8KkpRxSGDrOaodON39M3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSkRcquunqI2oDIxIXxoIbtB94cEdlgy+1r7NnjEiQugG7jqwWMD0zNOuLtR4/Zi4C9vVyDc0qc7kO9NjC6tlNdR7G/RLU3/ro1PU+/r6lMVdm/ibPlC5JT8gi2McrAQ5ipvsgq62QylXnidmqOmqlr0SQy0/hlGyNoZWmKy79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK4noB5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK4noB5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C332DC2BBFC;
	Wed, 19 Jun 2024 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803772;
	bh=fp5dhBdtQielZMFVxhekSx8KkpRxSGDrOaodON39M3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mK4noB5ilkzKI7aF0JnKVwhz61VWTFH06ktl0Za+UM8gAGmvxeYAqmhTjZFSAdLnk
	 4eYrN9HUe+Ck39lfDQ/HQ4OdFl5UP0BLLY673AoH2Gl+ltEVXIV/fd+WLIk6n1CmzD
	 Zmp0QpYkCwSjd/OGwZXwBb7dbPL2MIZEaxFen9OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aapo Vienamo <aapo.vienamo@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 097/217] thunderbolt: debugfs: Fix margin debugfs node creation condition
Date: Wed, 19 Jun 2024 14:55:40 +0200
Message-ID: <20240619125600.433730217@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aapo Vienamo <aapo.vienamo@linux.intel.com>

commit 985cfe501b74f214905ab4817acee0df24627268 upstream.

The margin debugfs node controls the "Enable Margin Test" field of the
lane margining operations. This field selects between either low or high
voltage margin values for voltage margin test or left or right timing
margin values for timing margin test.

According to the USB4 specification, whether or not the "Enable Margin
Test" control applies, depends on the values of the "Independent
High/Low Voltage Margin" or "Independent Left/Right Timing Margin"
capability fields for voltage and timing margin tests respectively. The
pre-existing condition enabled the debugfs node also in the case where
both low/high or left/right margins are returned, which is incorrect.
This change only enables the debugfs node in question, if the specific
required capability values are met.

Signed-off-by: Aapo Vienamo <aapo.vienamo@linux.intel.com>
Fixes: d0f1e0c2a699 ("thunderbolt: Add support for receiver lane margining")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/debugfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -927,8 +927,9 @@ static void margining_port_init(struct t
 	debugfs_create_file("run", 0600, dir, port, &margining_run_fops);
 	debugfs_create_file("results", 0600, dir, port, &margining_results_fops);
 	debugfs_create_file("test", 0600, dir, port, &margining_test_fops);
-	if (independent_voltage_margins(usb4) ||
-	    (supports_time(usb4) && independent_time_margins(usb4)))
+	if (independent_voltage_margins(usb4) == USB4_MARGIN_CAP_0_VOLTAGE_HL ||
+	    (supports_time(usb4) &&
+	     independent_time_margins(usb4) == USB4_MARGIN_CAP_1_TIME_LR))
 		debugfs_create_file("margin", 0600, dir, port, &margining_margin_fops);
 }
 


