Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B9D13D297;
	Tue, 21 Jan 2025 07:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737446145; cv=none; b=dNEvhpPmEs67TCPKj8zfk+eKCkvd0Mwo9RnbJgG+RS4PvK8gkE3koKJZDrw3PdcmYdZzP1F6lz/+RCVCjUGNgunmFa5pCkNbMtlrnbnwLrSva3b/USr/5gAd4ZLxV3v9f3D/uTGoNionzOQ0sdnrRZxhTGRSaBjylmz5IMYlEDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737446145; c=relaxed/simple;
	bh=FPxLf+uoqV1ToR21HGH891Ku97mvYCTKCW3s+sB7GCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chRIsFEqLd8etrTTSu46/EQvISxAMtz1/WhTyES413zChPmJD8uq7DbC3TV4v3H+cB5ejlB82KDc2yy/pexqufo2LGY3DM8OaE9T0f/DFkZjz/bmx+w7ErZDfoqSOQLec0Zd80XtFL1WJrza49JOvNOtwBl31diYMmoJ9A5BoZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhOgLREJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhOgLREJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0404C4CEE3;
	Tue, 21 Jan 2025 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737446145;
	bh=FPxLf+uoqV1ToR21HGH891Ku97mvYCTKCW3s+sB7GCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zhOgLREJSdjFSuryeqDTAu6gyhBVVZ7r5DlXv3+uPDa/tezk4FsNM8/uoPBCfE4Aj
	 B5Tyjda4iMX7YJb8UE/6U+35lyPnNCkbTRcTefQIC0qXPE/soqEnLgTzqefDDoc6DD
	 7lxwyOTdnxEGoypdNJCDkW3uOMn/fXp6zr4b0tOM=
Date: Tue, 21 Jan 2025 08:55:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH 6.6 010/129] ovl: do not encode lower fh with upper
 sb_writers held
Message-ID: <2025012118-handclap-encounter-af04@gregkh>
References: <20250115103554.357917208@linuxfoundation.org>
 <20250115103554.776405922@linuxfoundation.org>
 <ACD4D6CC-C4D5-4657-A805-03C34559046E@cloudflare.com>
 <CAOQ4uxj21U_=_Lj0AfDHmLt2wAjQG3vhYh9hXyZ=KG-J+AUOxg@mail.gmail.com>
 <CALrw=nH2gMfZUf=7rFSDRwD7bYzm5isvaY8rVPSG-6cf21OAfA@mail.gmail.com>
 <CAOQ4uxj+dRP2MwaOzKPbaryv9HuxmmONhug_95ATCpZHP-pzWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxj+dRP2MwaOzKPbaryv9HuxmmONhug_95ATCpZHP-pzWw@mail.gmail.com>

On Mon, Jan 20, 2025 at 09:45:40PM +0100, Amir Goldstein wrote:
> On Mon, Jan 20, 2025 at 9:14 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
> >
> > On Mon, Jan 20, 2025 at 6:54 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Mon, Jan 20, 2025 at 6:09 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
> > > >
> > > >
> > > >
> > > > > On 15 Jan 2025, at 10:36, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: Amir Goldstein <amir73il@gmail.com>
> > > > >
> > > > > [ Upstream commit 5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
> > > > >
> > > > > When lower fs is a nested overlayfs, calling encode_fh() on a lower
> > > > > directory dentry may trigger copy up and take sb_writers on the upper fs
> > > > > of the lower nested overlayfs.
> > > > >
> > > > > The lower nested overlayfs may have the same upper fs as this overlayfs,
> > > > > so nested sb_writers lock is illegal.
> > > > >
> > > > > Move all the callers that encode lower fh to before ovl_want_write().
> > > > >
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > Stable-dep-of: c45beebfde34 ("ovl: support encoding fid from inode with no alias")
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > >
> > > > Hi,
> > > >
> > > > This patch seems to trigger the following warning on 6.6.72, when running simple “$ docker run --rm -it debian” (creating a container):
> > > >
> > > > ------------[ cut here ]------------
> > > > WARNING: CPU: 12 PID: 668 at fs/namespace.c:1245 cleanup_mnt+0x130/0x150
> > > > Modules linked in: xt_conntrack(E) nft_chain_nat(E) xt_MASQUERADE(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) stp(E) llc(E) xfrm_user(E) xfrm_algo(E) xt_addrtype(E) nft_compat(E) nf_tables(E) overlay(E) kvm_amd(E) ccp(E) kvm(E) irqbypass(E) crc32_pclmul(E) sha512_ssse3(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) crypto_simd(E) cryptd(E) iTCO_wdt(E) virtio_console(E) virtio_balloon(E) iTCO_vendor_support(E) tiny_power_button(E) button(E) sch_fq_codel(E) fuse(E) nfnetlink(E) vsock_loopback(E) vmw_vsock_virtio_transport_common(E) vsock(E) efivarfs(E) ip_tables(E) x_tables(E) virtio_net(E) net_failover(E) virtio_blk(E) virtio_scsi(E) failover(E) crc32c_intel(E) i2c_i801(E) virtio_pci(E) virtio_pci_legacy_dev(E) i2c_smbus(E) lpc_ich(E) virtio_pci_modern_dev(E) mfd_core(E) virtio(E) virtio_ring(E)
> > > > CPU: 12 PID: 668 Comm: dockerd Tainted: G E 6.6.71+ #18
> > > > Hardware name: KubeVirt None/RHEL, BIOS edk2-20230524-3.el9 05/24/2023
> > > > RIP: 0010:cleanup_mnt+0x130/0x150
> > > > Code: 2c 01 00 00 85 c0 75 16 e8 6d fb ff ff eb 8a c7 87 2c 01 00 00 00 00 00 00 e9 6a ff ff ff c7 87 2c 01 00 00 00 00 00 00 eb de <0f> 0b 48 83 bd 30 01 00 00 00 0f 84 e9 fe ff ff 48 89 ef e8 18 e7
> > > > RSP: 0018:ffffc9000095fec8 EFLAGS: 00010282
> > > > RAX: 00000000fffffffe RBX: 0000000000000000 RCX: 0000000000000010
> > > > RDX: 0000000000000010 RSI: 0000000000000010 RDI: 0000000000000010
> > > > RBP: ffff888109ea57c0 R08: ffffffffbc27ab60 R09: 0000000000000000
> > > > R10: 0000000000037420 R11: 0000000000000000 R12: ffff88810acba9bc
> > > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > > > FS: 00007f1041ffb6c0(0000) GS:ffff88903fc00000(0000) knlGS:0000000000000000
> > > > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 000000c000b7f02f CR3: 00000001034ca002 CR4: 0000000000770ee0
> > > > PKRU: 55555554
> > > > Call Trace:
> > > > <TASK>
> > > > ? cleanup_mnt+0x130/0x150
> > > > ? __warn+0x81/0x130
> > > > ? cleanup_mnt+0x130/0x150
> > > > ? report_bug+0x16f/0x1a0
> > > > ? handle_bug+0x53/0x90
> > > > ? exc_invalid_op+0x17/0x70
> > > > ? asm_exc_invalid_op+0x1a/0x20
> > > > ? cleanup_mnt+0x130/0x150
> > > > ? cleanup_mnt+0x13/0x150
> > > > task_work_run+0x5d/0x90
> > > > exit_to_user_mode_prepare+0xf8/0x100
> > > > syscall_exit_to_user_mode+0x21/0x40
> > > > ? srso_alias_return_thunk+0x5/0xfbef5
> > > > do_syscall_64+0x45/0x90
> > > > entry_SYSCALL_64_after_hwframe+0x60/0xca
> > > > RIP: 0033:0x55d0e0726dee
> > > > Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
> > > > RSP: 002b:000000c000145a10 EFLAGS: 00000216 ORIG_RAX: 00000000000000a6
> > > > RAX: 0000000000000000 RBX: 000000c000b7fce0 RCX: 000055d0e0726dee
> > > > RDX: 0000000000000000 RSI: 0000000000000002 RDI: 000000c000b7fce0
> > > > RBP: 000000c000145a50 R08: 0000000000000000 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000216 R12: 000000c000b7fce0
> > > > R13: 0000000000000000 R14: 000000c000b06e00 R15: 1fffffffffffffff
> > > > </TASK>
> > > > ---[ end trace 0000000000000000 ]—
> > > >
> > > > This commit was pointed by my bisecting 6.6.71..6.6.72, but to double-check it I had to revert the following commits to make 6.6.72 compile and not exhibit the issue:
> > >
> > > Can you say what the compile error was?
> > > Maybe it is easy to fix without reverting the entire bunch.
> >
> > Just to revert 26423e18cd6f I needed to revert a3f8a2b13a27 as well
> > (otherwise there were conflicts). But then the compilation failed with
> >
> > fs/overlayfs/export.c: In function ‘ovl_dentry_to_fid’:
> > fs/overlayfs/export.c:255:67: error: ‘dentry’ undeclared (first use in
> > this function)
> >   255 |         fh = ovl_encode_real_fh(ofs, enc_lower ?
> > ovl_dentry_lower(dentry) :
> >       |                                                                   ^~~~~~
> >
> > so I had to revert a1a541fbfa7e as well
> 
> Care to try this backport branch without the buggy dependency
> based off of v6.6.71:
> 
> https://github.com/amir73il/linux/commits/ovl-6.6.y/
> 
> Sorry, I had no time to test this, but the conflicts are pretty trivial.
> I also added a manual backport of another related patch from 6.12.y
> while at it.
> 
> >
> > > Just by looking, it is hard for me to guess what caused the scripts to
> > > pull in this dependency patch.
> > >
> > > >
> > > >   * a3f8a2b13a277d942c810d2ccc654d5bc824a430 (“ovl: pass realinode to ovl_encode_real_fh() instead of realdentry
> > > > ”) [ Upstream commit 07aeefae7ff44d80524375253980b1bdee2396b0 ]
> > > >   * 26423e18cd6f709ca4fe7194c29c11658cd0cdd0 (“ovl: do not encode lower fh with upper sb_writers held”) [ Upstream commit 5b02bfc1e7e3811c5bf7f0fa626a0694d0dbbd77 ]
> > > >   * a1a541fbfa7e97c1100144db34b57553d7164ce5 ("ovl: support encoding fid from inode with no alias”) [ Upstream commit c45beebfde34aa71afbc48b2c54cdda623515037 ]
> > > >
> 
> These should be reverted in 6.6.y apply the backports from my branch instead.

Ok, let me revert them now, do a release, and then can you submit a
working set of patches we can apply again?

thanks,

greg k-h
