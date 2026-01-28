Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A1E1885A5;
	Wed, 28 Jan 2026 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614471; cv=none; b=r8IAm5e0xTrmkdZCpC9KlgsSkx38NmFWwCL9+1rZTOjuKwWbQVXsJje5lgZuwosulZM/x7/YuxI4OtaevcJ13RULmNqK3+yAOx1xkv+v2K05J4+nscYMEcGYULMsKyZap26UqSDVbOXFDMYudtDqwEyjRRY5c4Eb2EmMhCdXFaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614471; c=relaxed/simple;
	bh=5OFGFXRIKWS/vOLCDGcdyn+PeQUtvOHh0V9jYrFqdII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbP3MQVBKadZAjwadOOqN+rPCjdrPD7bEsOM1mZKlsc1LkDmsKoonsOjYcuF+zc0twF/oW0QGlhVZkpBV3uQbsCNRUBLafBJp8HDo0g73EvqjNwWtKyUvlmRv2jvMYfN6AA7886muCcxrruMj/XGEIp9PcD9pCk16JXai0+LhdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYkzdTM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYkzdTM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11F2C4CEF7;
	Wed, 28 Jan 2026 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614471;
	bh=5OFGFXRIKWS/vOLCDGcdyn+PeQUtvOHh0V9jYrFqdII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYkzdTM6HAafkPaMkyQKQfA/MR9SIy2b9kUxh+5gyQpTs4SYoKAHiZABfUvG1mfun
	 Smz4nIXCgPcgl4cJpLDK+wyFG2HxpNP/wD/C6Zd240pPQABOZMm3ryBtGBZavohFkZ
	 ZG8XrLnzBCCAbImOoArbZnsEoyq0GC4tBqC4GMRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.6 147/254] comedi: Fix getting range information for subdevices 16 to 255
Date: Wed, 28 Jan 2026 16:22:03 +0100
Message-ID: <20260128145350.103485334@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 10d28cffb3f6ec7ad67f0a4cd32c2afa92909452 upstream.

The `COMEDI_RANGEINFO` ioctl does not work properly for subdevice
indices above 15.  Currently, the only in-tree COMEDI drivers that
support more than 16 subdevices are the "8255" driver and the
"comedi_bond" driver.  Making the ioctl work for subdevice indices up to
255 is achievable.  It needs minor changes to the handling of the
`COMEDI_RANGEINFO` and `COMEDI_CHANINFO` ioctls that should be mostly
harmless to user-space, apart from making them less broken.  Details
follow...

The `COMEDI_RANGEINFO` ioctl command gets the list of supported ranges
(usually with units of volts or milliamps) for a COMEDI subdevice or
channel.  (Only some subdevices have per-channel range tables, indicated
by the `SDF_RANGETYPE` flag in the subdevice information.)  It uses a
`range_type` value and a user-space pointer, both supplied by
user-space, but the `range_type` value should match what was obtained
using the `COMEDI_CHANINFO` ioctl (if the subdevice has per-channel
range tables)  or `COMEDI_SUBDINFO` ioctl (if the subdevice uses a
single range table for all channels).  Bits 15 to 0 of the `range_type`
value contain the length of the range table, which is the only part that
user-space should care about (so it can use a suitably sized buffer to
fetch the range table).  Bits 23 to 16 store the channel index, which is
assumed to be no more than 255 if the subdevice has per-channel range
tables, and is set to 0 if the subdevice has a single range table.  For
`range_type` values produced by the `COMEDI_SUBDINFO` ioctl, bits 31 to
24 contain the subdevice index, which is assumed to be no more than 255.
But for `range_type` values produced by the `COMEDI_CHANINFO` ioctl,
bits 27 to 24 contain the subdevice index, which is assumed to be no
more than 15, and bits 31 to 28 contain the COMEDI device's minor device
number for some unknown reason lost in the mists of time.  The
`COMEDI_RANGEINFO` ioctl extract the length from bits 15 to 0 of the
user-supplied `range_type` value, extracts the channel index from bits
23 to 16 (only used if the subdevice has per-channel range tables),
extracts the subdevice index from bits 27 to 24, and ignores bits 31 to
28.  So for subdevice indices 16 to 255, the `COMEDI_SUBDINFO` or
`COMEDI_CHANINFO` ioctl will report a `range_type` value that doesn't
work with the `COMEDI_RANGEINFO` ioctl.  It will either get the range
table for the subdevice index modulo 16, or will fail with `-EINVAL`.

To fix this, always use bits 31 to 24 of the `range_type` value to hold
the subdevice index (assumed to be no more than 255).  This affects the
`COMEDI_CHANINFO` and `COMEDI_RANGEINFO` ioctls.  There should not be
anything in user-space that depends on the old, broken usage, although
it may now see different values in bits 31 to 28 of the `range_type`
values reported by the `COMEDI_CHANINFO` ioctl for subdevices that have
per-channel subdevices.  User-space should not be trying to decode bits
31 to 16 of the `range_type` values anyway.

Fixes: ed9eccbe8970 ("Staging: add comedi core")
Cc: stable@vger.kernel.org #5.17+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20251203162438.176841-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c |    2 +-
 drivers/comedi/range.c       |    2 +-
 include/uapi/linux/comedi.h  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -1099,7 +1099,7 @@ static int do_chaninfo_ioctl(struct come
 		for (i = 0; i < s->n_chan; i++) {
 			int x;
 
-			x = (dev->minor << 28) | (it->subdev << 24) | (i << 16) |
+			x = (it->subdev << 24) | (i << 16) |
 			    (s->range_table_list[i]->length);
 			if (put_user(x, it->rangelist + i))
 				return -EFAULT;
--- a/drivers/comedi/range.c
+++ b/drivers/comedi/range.c
@@ -52,7 +52,7 @@ int do_rangeinfo_ioctl(struct comedi_dev
 	const struct comedi_lrange *lr;
 	struct comedi_subdevice *s;
 
-	subd = (it->range_type >> 24) & 0xf;
+	subd = (it->range_type >> 24) & 0xff;
 	chan = (it->range_type >> 16) & 0xff;
 
 	if (!dev->attached)
--- a/include/uapi/linux/comedi.h
+++ b/include/uapi/linux/comedi.h
@@ -640,7 +640,7 @@ struct comedi_chaninfo {
 
 /**
  * struct comedi_rangeinfo - used to retrieve the range table for a channel
- * @range_type:		Encodes subdevice index (bits 27:24), channel index
+ * @range_type:		Encodes subdevice index (bits 31:24), channel index
  *			(bits 23:16) and range table length (bits 15:0).
  * @range_ptr:		Pointer to array of @struct comedi_krange to be filled
  *			in with the range table for the channel or subdevice.


