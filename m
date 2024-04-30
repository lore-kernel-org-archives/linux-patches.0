Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C932512B176;
	Tue, 30 Apr 2024 11:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474855; cv=none; b=V3LA2q0ffs6uVs7tGQgQ96ZlyZUNUFAjt/GJt5uagAMrPHl0uKCfxME/dqMt0cisqC3997UkAAO93Kh6/aYvcn942Y23U/0YFwJePBy42aIqtW1ijFGXen091X6i6y7L9Ka1XX4ypdzyFDZp65I87190d3RMTC06sAHVfldDrao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474855; c=relaxed/simple;
	bh=MzhOfTSFrPViUHEymWqnKNMlRnmRa75ca1wIFxDJnDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfdTznGo21RSe4fuMYKQTItEFW/sBwVD2tW+NOPK+SBsyJijZuO1ahzCfVUe6pdN0sesvPqeZsJZ91eNZWAi09ekvPfhDULPdqdAyztDNnezeZT9tmAJ7FNxM1HfpycamZml3LqRpIQL3aH6rIORVmxMPPV7GPVM8CmT/HP1jhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PerfW2R2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PerfW2R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C14C2BBFC;
	Tue, 30 Apr 2024 11:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474855;
	bh=MzhOfTSFrPViUHEymWqnKNMlRnmRa75ca1wIFxDJnDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PerfW2R2QFNi6sHM3Y/Kn6qYCEHHERXntMIm223GwKuUkV4fRPS4+spF+378WUBAl
	 c9xec5es3/RlO5q5ZOf6Ii69l6pwrxu2unGIuHDo9uO8ID5e9u9c8FVWXpbo7Q13Ta
	 K9fsCqDvJUmjzBR3TWf+wWf4gjyN8DKC4ozvdzpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 057/138] USB: serial: option: add support for Fibocom FM650/FG650
Date: Tue, 30 Apr 2024 12:39:02 +0200
Message-ID: <20240430103051.108174125@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuanhong Guo <gch981213@gmail.com>

commit fb1f4584b1215e8c209f6b3a4028ed8351a0e961 upstream.

Fibocom FM650/FG650 are 5G modems with ECM/NCM/RNDIS/MBIM modes.
This patch adds support to all 4 modes.

In all 4 modes, the first serial port is the AT console while the other
3 appear to be diagnostic interfaces for dumping modem logs.

usb-devices output for all modes:

ECM:
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  5 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2cb7 ProdID=0a04 Rev=04.04
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=FG650 Module
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 5 Cfg#= 1 Atr=c0 MxPwr=504mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=06 Prot=00 Driver=cdc_ether
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_ether
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

NCM:
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  6 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2cb7 ProdID=0a05 Rev=04.04
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=FG650 Module
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=c0 MxPwr=504mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0d Prot=00 Driver=cdc_ncm
E:  Ad=82(I) Atr=03(Int.) MxPS=  16 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=01 Driver=cdc_ncm
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

RNDIS:
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2cb7 ProdID=0a06 Rev=04.04
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=FG650 Module
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=c0 MxPwr=504mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=e0(wlcon) Sub=01 Prot=03 Driver=rndis_host
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

MBIM:
T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  7 Spd=5000 MxCh= 0
D:  Ver= 3.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=2cb7 ProdID=0a07 Rev=04.04
S:  Manufacturer=Fibocom Wireless Inc.
S:  Product=FG650 Module
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=c0 MxPwr=504mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=32ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=85(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms

Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2279,6 +2279,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a3, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a4, 0xff),			/* Fibocom FM101-GL (laptop MBIM) */
 	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0a04, 0xff) },			/* Fibocom FM650-CN (ECM mode) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0a05, 0xff) },			/* Fibocom FM650-CN (NCM mode) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0a06, 0xff) },			/* Fibocom FM650-CN (RNDIS mode) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0a07, 0xff) },			/* Fibocom FM650-CN (MBIM mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2df3, 0x9d03, 0xff) },			/* LongSung M5710 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */


