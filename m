Received: from granite.fifsource.com (granite.fifsource.com [173.255.216.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062F420ADD9
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.255.216.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734027690; cv=none; b=oB+yZOqr59YN+xXzNFKTrFrTDEux+6ysJp3z6z28Xtyez9vltRKb4zOfnhTfYFUn/xo7w4RxLhl85iMAzs4+5739LGlcy98bFpZaxar3IC0oXusEdn11z/QLKSFqBSb2OjJG+jb1V+95h5VJo3mlU/L+a4J9CmgW17VgUWKzVmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734027690; c=relaxed/simple;
	bh=NIkDmvBjolDoZEQipRon8YsqoPGSaBfwo7XhYHo8DyY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T5BibY6kBoJTJqqWXVO5abO00oKtsfn/0ml2i8FDvFwh0/yh0CrehCaIGWvlsW89Wr9m96BN+ecL+6HNAS4GDO4fVbpP3PysSKTRIPkOS/RuZaX+f5UaOT37d/Mfz1szILnpVZaUVrc24xav590Na6HdtJxW0Jqq3fMapJdBpXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fifi.org; spf=pass smtp.mailfrom=fifi.org; arc=none smtp.client-ip=173.255.216.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fifi.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fifi.org
Received: from ceramic.fifi.org (107-142-44-66.lightspeed.sntcca.sbcglobal.net [107.142.44.66])
	(using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by granite.fifsource.com (Postfix) with ESMTPSA id 80EF34076;
	Thu, 12 Dec 2024 10:12:54 -0800 (PST)
Message-ID: <4ab51fdc37c39bd077b4bcea281d301af4c3ef1a.camel@fifi.org>
Subject: Re: [PATCH 6.12 162/466] Revert "readahead: properly shorten
 readahead when falling back to do_page_cache_ra()"
From: Philippe Troin <phil@fifi.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Anders Blomdell <anders.blomdell@gmail.com>, 
 Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>
Date: Thu, 12 Dec 2024 10:12:54 -0800
In-Reply-To: <20241212144313.202242815@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
	 <20241212144313.202242815@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-12-12 at 15:55 +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.=C2=A0 If anyone has any objections, please let
> me know.
>=20
> ------------------
>=20
> From: Jan Kara <jack@suse.cz>
>=20
> commit a220d6b95b1ae12c7626283d7609f0a1438e6437 upstream.
>=20
> This reverts commit 7c877586da3178974a8a94577b6045a48377ff25.

Isn't that moot now with 0938b1614648d5fbd832449a5a8a1b51d985323d that
in Linus's tree? It's not in 6.12 (yet?).
It may be worth backporting 0938b1614 to the stable tree, but it's
beyond my pay grade.

Phil.

https://lore.kernel.org/all/20241017062342.478973-1-kernel@pankajraghav.com=
/T/#u

commit 0938b1614648d5fbd832449a5a8a1b51d985323d
Author: Pankaj Raghav <p.raghav@samsung.com>
Date:   Thu Oct 17 08:23:42 2024 +0200

    mm: don't set readahead flag on a folio when lookahead_size > nr_to_rea=
d
   =20
    The readahead flag is set on a folio based on the lookahead_size and
    nr_to_read.  For example, when the readahead happens from index to inde=
x +
    nr_to_read, then the readahead `mark` offset from index is set at
    nr_to_read - lookahead_size.
   =20
    There are some scenarios where the lookahead_size > nr_to_read.  For
    example, readahead window was created, but the file was truncated befor=
e
    the readahead starts.  do_page_cache_ra() will clamp the nr_to_read if =
the
    readahead window extends beyond EOF after truncation.  If this happens,
    readahead flag should not be set on any folio on the current readahead
    window.
   =20
    The current calculation for `mark` with mapping_min_order > 0 gives
    incorrect results when lookahead_size > nr_to_read due to rounding up
    operation:
   =20
    index =3D 128
    nr_to_read =3D 16
    lookahead_size =3D 28
    mapping_min_order =3D 4 (16 pages)
   =20
    ra_folio_index =3D round_up(128 + 16 - 28, 16) =3D 128;
    mark =3D 128 - 128 =3D 0; # offset from index to set RA flag
   =20
    In the above example, the lookahead_size is actually lying outside the
    current readahead window.  Without this patch, RA flag will be set
    incorrectly on the folio at index 128.  This can lead to marking the
    readahead flag on the wrong folio, therefore, triggering a readahead wh=
en
    it is not necessary.
   =20
    Explicitly initialize `mark` to be ULONG_MAX and only calculate it when
    lookahead_size is within the readahead window.

diff --git a/mm/readahead.c b/mm/readahead.c
index 3dc6c7a128dd..475d2940a1ed 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -206,9 +206,9 @@ void page_cache_ra_unbounded(struct readahead_control *=
ractl,
                unsigned long nr_to_read, unsigned long lookahead_size)
 {
        struct address_space *mapping =3D ractl->mapping;
-       unsigned long ra_folio_index, index =3D readahead_index(ractl);
+       unsigned long index =3D readahead_index(ractl);
        gfp_t gfp_mask =3D readahead_gfp_mask(mapping);
-       unsigned long mark, i =3D 0;
+       unsigned long mark =3D ULONG_MAX, i =3D 0;
        unsigned int min_nrpages =3D mapping_min_folio_nrpages(mapping);
=20
        /*
@@ -232,9 +232,14 @@ void page_cache_ra_unbounded(struct readahead_control =
*ractl,
         * index that only has lookahead or "async_region" to set the
         * readahead flag.
         */
-       ra_folio_index =3D round_up(readahead_index(ractl) + nr_to_read - l=
ookahead_size,
-                                 min_nrpages);
-       mark =3D ra_folio_index - index;
+       if (lookahead_size <=3D nr_to_read) {
+               unsigned long ra_folio_index;
+
+               ra_folio_index =3D round_up(readahead_index(ractl) +
+                                         nr_to_read - lookahead_size,
+                                         min_nrpages);
+               mark =3D ra_folio_index - index;
+       }
        nr_to_read +=3D readahead_index(ractl) - index;
        ractl->_index =3D index;

