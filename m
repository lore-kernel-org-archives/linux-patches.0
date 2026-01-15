Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E4B3BF30E;
	Thu, 15 Jan 2026 17:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497893; cv=none; b=Lwhej1S3PqHnvWX7PZ1sBhhwTmo7Y1TrYqn2C5GCliOOvfXAPFOoxZYPN3UGnVM1nUKsIpaup5Dop+GvnAB0h4tvYXB4ZwVkjHeN3jJ/2mIUX4P7QpnPAvGiFc5I7OS1rf0CMMI75t48LDUG8K+7id7DAnuFwhckextw3aekoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497893; c=relaxed/simple;
	bh=Us4WNkR9nGayZMuyw2t0YMNcBek7vFeVjQ3gKhpfzLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQesGNEr7TUT1CVV8yCVsPtBCJw4/6cgZ/ttPCLQkB6XwkqW2YV386Htg8Kk300qSXc/5Kdkftzlvg2LT6TQFgk0G/XVf8+Nck8NmqyeY4KBoDQmJSgUga0XWsbLYo/5prrMEVTD5Zed+v4bt7eGZQCYjb+YGYI56I9TDp0Rq70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbT+dghG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbT+dghG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB122C116D0;
	Thu, 15 Jan 2026 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497893;
	bh=Us4WNkR9nGayZMuyw2t0YMNcBek7vFeVjQ3gKhpfzLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbT+dghG0gz22W05dQpYEkI1to3tJyeipBkiEdhSOMulbTIYECzP66YpZh68BFeQV
	 GsD3DVUdKHKDTnpao6+ZdlRLKYqis4gimGSJzXO7PJw0lZej2iicqCIrYFi3EerlpV
	 U8Q5N/JwtfkdBLuAjS/Dzw0wNEh8HmKfXcjmiB0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>
Subject: [PATCH 5.15 207/554] i3c: fix uninitialized variable use in i2c setup
Date: Thu, 15 Jan 2026 17:44:33 +0100
Message-ID: <20260115164253.746786347@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Jamie Iles <quic_jiles@quicinc.com>

commit 6cbf8b38dfe3aabe330f2c356949bc4d6a1f034f upstream.

Commit 31b9887c7258 ("i3c: remove i2c board info from i2c_dev_desc")
removed the boardinfo from i2c_dev_desc to decouple device enumeration from
setup but did not correctly lookup the i2c_dev_desc to store the new
device, instead dereferencing an uninitialized variable.

Lookup the device that has already been registered by address to store
the i2c client device.

Fixes: 31b9887c7258 ("i3c: remove i2c board info from i2c_dev_desc")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220308134226.1042367-1-quic_jiles@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2322,8 +2322,13 @@ static int i3c_master_i2c_adapter_init(s
 	 * We silently ignore failures here. The bus should keep working
 	 * correctly even if one or more i2c devices are not registered.
 	 */
-	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node)
+	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node) {
+		i2cdev = i3c_master_find_i2c_dev_by_addr(master,
+							 i2cboardinfo->base.addr);
+		if (WARN_ON(!i2cdev))
+			continue;
 		i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
+	}
 
 	return 0;
 }


