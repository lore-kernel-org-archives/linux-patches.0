Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5261AC423
	for <patches@lists.linux.dev>; Mon, 14 Oct 2024 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918132; cv=none; b=HyBEb8lDbCe04OCg+Q2hcnkOvraMStY2lYt8AGE90AhaNhhJ/b//yr58EWFQ8UVYjgbIzhU8yS8HnP1OLnKDXh3hfYx9X6K6vAgpZOMSsPZeEr1pmrG6tiOwb28mUbZLSHkixs6MB+feDDRmZMJah8WtnGeTxhZIXOosHSYaBm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918132; c=relaxed/simple;
	bh=kuHEkhk9Dd5aRVV0OGIJgFv3Bx75WUpIeytPubDNPFU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=NfB0DR3Q/Xv+/fEpG/LpgSvPudMNWUXnBxr6f7RyzQ0AOf3b79ehZOorhfFYFpqulm+PHfe8pH7UZEScsdfUDCQaq6D9+a1J0BrVks/K2qE4P23/6jX3cQmq4UeojWFwQY6d0zkimqKbOLoDJsUlGkI4wfZe2jwSTnIdYMqMwvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-203-oUAueilBOJijCu58RxRb9w-1; Mon, 14 Oct 2024 16:02:08 +0100
X-MC-Unique: oUAueilBOJijCu58RxRb9w-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 14 Oct
 2024 16:02:07 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 14 Oct 2024 16:02:07 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Oliver Neukum
	<oneukum@suse.com>, stable <stable@kernel.org>
Subject: RE: [PATCH 6.11 162/214] Revert "usb: yurex: Replace snprintf() with
 the safer scnprintf() variant"
Thread-Topic: [PATCH 6.11 162/214] Revert "usb: yurex: Replace snprintf() with
 the safer scnprintf() variant"
Thread-Index: AQHbHkZDH3rfvTqUHU24aAOWRp7JLLKGVUGg
Date: Mon, 14 Oct 2024 15:02:06 +0000
Message-ID: <25ee4ade0cc14a128733780ec71d4f50@AcuMS.aculab.com>
References: <20241014141044.974962104@linuxfoundation.org>
 <20241014141051.307451309@linuxfoundation.org>
In-Reply-To: <20241014141051.307451309@linuxfoundation.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Greg Kroah-Hartman
> Sent: 14 October 2024 15:20
>=20
> 6.11-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Oliver Neukum <oneukum@suse.com>
>=20
> commit 71c717cd8a2e180126932cc6851ff21c1d04d69a upstream.
>=20
> This reverts commit 86b20af11e84c26ae3fde4dcc4f490948e3f8035.
>=20
> This patch leads to passing 0 to simple_read_from_buffer()
> as a fifth argument, turning the read method into a nop.
> The change is fundamentally flawed, as it breaks the driver.

This failed my mail filter rules (don't ask...) so I read it.
The patch clearly broke the code, but it is pretty horrid.

A quick scan shows a CMD_LED of length 1 send uninitialised stack.
dev->bbu is usually 40 bits max, except when it is initialised to -1
or when a very large integer is supplied (c2 isn't masked).

Never mind the strange locking across slow operations.
There is pretty much no point holding a mutex across a copy_from_user()
into an on-stack structure.

...
> -=09if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN)) {
> -=09=09mutex_unlock(&dev->io_mutex);
> -=09=09return -EIO;

dev->bbu is s64 - that can never happen.
Apart from the initialisation to -1 (never checked for) it
is also always +ve.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

