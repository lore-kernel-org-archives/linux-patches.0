Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8507B13AF8
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 13:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; dkim=none
User-agent: mu4e 1.10.7; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: gregkh@linuxfoundation.org, Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com,patches@lists.linux.dev,stable@vger.kernel.org,linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6.5 211/285] btrfs: scrub: fix grouping of read IO
In-Reply-To: <20230917191058.870881178@linuxfoundation.org>
Date: Thu, 26 Oct 2023 14:31:39 +0100
Organization: Gentoo
Message-ID: <87fs1x1p93.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

'btrfs: scrub: fix grouping of read IO' seems to intorduce a
-Wmaybe-uninitialized warning (which becomes fatal with the kernel's
passed -Werror=3D...) with 6.5.9:

```
# CC      fs/btrfs/scrub.o
  x86_64-pc-linux-gnu-gcc -Wp,-MMD,fs/btrfs/.scrub.o.d -nostdinc -I/var/tmp=
/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/arch/x86/include -I.=
/arch/x86/include/generated -I/var/tmp/portage/sys-kernel/gentoo-kernel-6.5=
.9/work/linux-6.5/include -I./include -I/var/tmp/portage/sys-kernel/gentoo-=
kernel-6.5.9/work/linux-6.5/arch/x86/include/uapi -I./arch/x86/include/gene=
rated/uapi -I/var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5=
/include/uapi -I./include/generated/uapi -include /var/tmp/portage/sys-kern=
el/gentoo-kernel-6.5.9/work/linux-6.5/include/linux/compiler-version.h -inc=
lude /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/include=
/linux/kconfig.h -include /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/w=
ork/linux-6.5/include/linux/compiler_types.h -D__KERNEL__ -Werror -fmacro-p=
refix-map=3D/var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/=
=3D -std=3Dgnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-st=
rict-aliasing -Wall -Wundef -Werror=3Dimplicit-function-declaration -Werror=
=3Dimplicit-int -Werror=3Dreturn-type -Werror=3Dstrict-prototypes -Wno-form=
at-security -Wno-trigraphs -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx =
-fcf-protection=3Dbranch -fno-jump-tables -m64 -falign-jumps=3D1 -falign-lo=
ops=3D1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3D3 -mskip=
-rax-setup -march=3Dcore2 -mno-red-zone -mcmodel=3Dkernel -Wno-sign-compare=
 -fno-asynchronous-unwind-tables -mindirect-branch=3Dthunk-extern -mindirec=
t-branch-register -mindirect-branch-cs-prefix -mfunction-return=3Dthunk-ext=
ern -fno-jump-tables -mharden-sls=3Dall -fno-delete-null-pointer-checks -Wn=
o-frame-address -Wno-format-truncation -Wno-format-overflow -Wno-address-of=
-packed-member -O2 -fno-allow-store-data-races -Wframe-larger-than=3D2048 -=
fstack-protector-strong -Wno-main -Wno-unused-but-set-variable -Wno-unused-=
const-variable -Wno-dangling-pointer -fomit-frame-pointer -ftrivial-auto-va=
r-init=3Dzero -fno-stack-clash-protection -fzero-call-used-regs=3Dused-gpr =
-falign-functions=3D16 -Wvla -Wno-pointer-sign -Wcast-function-type -fstric=
t-flex-arrays=3D3 -Wno-stringop-truncation -Wno-stringop-overflow -Wno-rest=
rict -Wno-maybe-uninitialized -Wno-array-bounds -Wno-alloc-size-larger-than=
 -Wimplicit-fallthrough=3D5 -fno-strict-overflow -fno-stack-check -fconserv=
e-stack -Werror=3Ddate-time -Werror=3Dincompatible-pointer-types -Werror=3D=
designated-init -Wno-packed-not-aligned -DRANDSTRUCT -fplugin=3D./scripts/g=
cc-plugins/randomize_layout_plugin.so -fplugin-arg-randomize_layout_plugin-=
performance-mode -fplugin=3D./scripts/gcc-plugins/latent_entropy_plugin.so =
-fplugin=3D./scripts/gcc-plugins/structleak_plugin.so -fplugin=3D./scripts/=
gcc-plugins/stackleak_plugin.so -DLATENT_ENTROPY_PLUGIN -DSTRUCTLEAK_PLUGIN=
 -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-min-size=3D100 -fpl=
ugin-arg-stackleak_plugin-arch=3Dx86 -Wextra -Wunused -Wno-unused-parameter=
 -Wmissing-declarations -Wmissing-format-attribute -Wmissing-prototypes -Wo=
ld-style-definition -Wmissing-include-dirs -Wunused-but-set-variable -Wunus=
ed-const-variable -Wpacked-not-aligned -Wstringop-truncation -Wmaybe-uninit=
ialized -Wno-missing-field-initializers -Wno-sign-compare -Wno-type-limits =
-Wno-shift-negative-value -I /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.=
9/work/linux-6.5/fs/btrfs -I ./fs/btrfs    -DKBUILD_MODFILE=3D'"fs/btrfs/bt=
rfs"' -DKBUILD_BASENAME=3D'"scrub"' -DKBUILD_MODNAME=3D'"btrfs"' -D__KBUILD=
_MODNAME=3Dkmod_btrfs -c -o fs/btrfs/scrub.o /var/tmp/portage/sys-kernel/ge=
ntoo-kernel-6.5.9/work/linux-6.5/fs/btrfs/scrub.c
/var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs/scr=
ub.c: In function =E2=80=98scrub_simple_mirror.isra=E2=80=99:
/var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs/scr=
ub.c:2075:29: error: =E2=80=98found_logical=E2=80=99 may be used uninitiali=
zed [-Werror=3Dmaybe-uninitialized[https://gcc.gnu.org/onlinedocs/gcc/Warni=
ng-Options.html#index-Wmaybe-uninitialized]]
 2075 |                 cur_logical =3D found_logical + BTRFS_STRIPE_LEN;
/var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs/scr=
ub.c:2040:21: note: =E2=80=98found_logical=E2=80=99 was declared here
 2040 |                 u64 found_logical;
      |                     ^~~~~~~~~~~~~
```
