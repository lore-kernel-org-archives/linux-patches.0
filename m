Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE212F46
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 10:20:40 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 5EFD11C09F7; Wed, 16 Nov 2022 11:20:37 +0100 (CET)
Date: Wed, 16 Nov 2022 11:20:36 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+45d6ce7b7ad7ef455d03@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.0 134/190] nilfs2: fix deadlock in
 nilfs_count_free_blocks()
Message-ID: <Y3S5dFSZnPKXsvWZ@duo.ucw.cz>
References: <20221114124458.806324402@linuxfoundation.org>
 <20221114124504.652482817@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yeuuGazEakkzllCW"
Content-Disposition: inline
In-Reply-To: <20221114124504.652482817@linuxfoundation.org>


--yeuuGazEakkzllCW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20
> commit 8ac932a4921a96ca52f61935dbba64ea87bbd5dc upstream.
=2E..
> However, there is actually no need to take rwsem A in
> nilfs_count_free_blocks() because it, within the lock section, only reads
> a single integer data on a shared struct with
> nilfs_sufile_get_ncleansegs().  This has been the case after commit
> aa474a220180 ("nilfs2: add local variable to cache the number of clean
> segments"), that is, even before this bug was introduced.

Ok, but these days we have checkers that don't like reading variables
unlocked, and compiler theoretically could do something funny.

So this should have READ/WRITE_ONCE annotations... this is incomplete,
but should illustrate what is needed. Likely some helper for updating
ncleansegs should be introduced.

Best regards,
								Pavel

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 63722475e17e..58dddc0b1d88 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -122,7 +122,7 @@ static void nilfs_sufile_mod_counter(struct buffer_head=
 *header_bh,
  */
 unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
 {
-	return NILFS_SUI(sufile)->ncleansegs;
+	return READ_ONCE(NILFS_SUI(sufile)->ncleansegs);
 }
=20
 /**
@@ -418,7 +418,9 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, =
__u64 segnum,
 	kunmap_atomic(kaddr);
=20
 	nilfs_sufile_mod_counter(header_bh, -1, 1);
-	NILFS_SUI(sufile)->ncleansegs--;
+	/* nilfs_sufile_get_ncleansegs() leads this without taking lock */
+	WRITE_ONCE(NILFS_SUI(sufile)->ncleansegs,
+		   READ_ONCE(NILFS_SUI(sufile)->ncleansegs) - 1);
=20
 	mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yeuuGazEakkzllCW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S5dAAKCRAw5/Bqldv6
8qwqAKCg9Pr7u0jsNSiROsNWDANK8ix62ACdEc8J7LbTneILBlrZaR9AaKObRus=
=6J+9
-----END PGP SIGNATURE-----

--yeuuGazEakkzllCW--
